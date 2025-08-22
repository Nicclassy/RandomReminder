//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import Foundation

final class ReminderManager {
    static let shared = ReminderManager(preview: true)

    private let remind = true
    private let persistentChanges = false

    private var reminders: [RandomReminder]
    private var timerThread: Thread!
    private var tickInterval: ReminderTickInterval = .seconds(1)

    private var queue = DispatchQueue(
        label: Constants.bundleID + ".ReminderManager.queue",
        qos: .userInitiated
    )

    private let startedRemindersLock = NSLock()
    private var startedReminders: [ReminderActivatorService] = []

    private(set) var todaysDay: ReminderDayOptions = .today

    var reminderIds: Set<ReminderID> {
        queue.sync {
            Set(reminders.map(\.id))
        }
    }

    var audioFiles: [ReminderAudioFile] {
        queue.sync {
            reminders.compactMap(\.activationEvents.audio)
        }
    }

    private init(_ reminders: [RandomReminder]) {
        self.reminders = reminders
    }

    private convenience init(preview: Bool = false) {
        let reminders: [RandomReminder] = if preview {
            Self.previewReminders()
        } else {
            Self.reminderFileNames().compactMap { filename in
                guard let reminder: RandomReminder = ReminderSerializer.load(filename: filename) else {
                    FancyLogger.warn("Cannot load file \(filename)")
                    return nil
                }
                return reminder
            }
        }

        self.init(reminders)
    }

    private static func reminderFileNames() -> [String] {
        guard let filenames = try? FileManager.default.contentsOfDirectory(atPath: StoredReminders.url.path()) else {
            fatalError("Could not get reminders' filenames")
        }

        return filenames.filter { StoredReminders.filenamePattern.contains(captureNamed: $0) }
    }

    func setup() {
        // All credits go to
        // https://hackernoon.com/how-to-use-runloop-in-ios-applications
        // for correct timer implementation
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDayChanged),
            name: .NSCalendarDayChanged,
            object: nil
        )
        setReminderStates()

        guard remind else { return }

        timerThread = Thread {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                let date = Date()
                queue.sync {
                    for reminder in reminders where !reminder.hasPast {
                        tick(reminder, on: date)
                    }
                }
            }
            RunLoop.current.add(timer, forMode: .default)
            RunLoop.current.run()
        }
        timerThread.start()
    }

    func modify(_ reminder: RandomReminder, changes: (RandomReminder) -> Void) {
        changes(reminder)
        ReminderModificationController.shared.postRefreshRemindersNotification()
        if persistentChanges {
            DispatchQueue.global(qos: .utility).async {
                ReminderSerializer.save(reminder, filename: reminder.filename())
            }
        }
    }

    func reminderCanActivate(_ reminder: RandomReminder) -> Bool {
        guard !SchedulingPreferences.shared.remindersArePaused else {
            return false
        }

        guard !reminder.eponymous || reminder.days.contains(todaysDay) else {
            return false
        }

        return true
    }

    func reminderExists(_ reminder: RandomReminder) -> Bool {
        queue.sync {
            reminders.lazy.contains(reminder)
        }
    }

    func upcomingReminders() -> [RandomReminder] {
        queue.sync {
            reminders.lazy.filter { !$0.hasPast }.sorted { $0.compare(with: $1) }
        }
    }

    func pastReminders() -> [RandomReminder] {
        queue.sync {
            reminders.lazy.filter { $0.hasPast }.sorted { $0.compare(with: $1) }
        }
    }

    func reminderWithSameTitleExists(as title: String) -> Bool {
        queue.sync {
            reminders.lazy.contains { $0.content.title == title }
        }
    }

    func nextAvailableId() -> ReminderID {
        (.first...).first { !reminderIds.map(\.value).contains($0.value) }!
    }

    func addReminder(_ reminder: RandomReminder) {
        queue.sync {
            reminders.append(reminder)
            tick(reminder, on: .now)
        }

        if persistentChanges {
            DispatchQueue.global(qos: .utility).async {
                ReminderSerializer.save(reminder, filename: reminder.filename())
            }
        }
    }

    func removeReminder(_ reminder: RandomReminder) {
        if remind && reminder.state == .started {
            stopReminder(reminder, permanent: true)
            ActiveReminderManager.shared.deactivateReminder(reminder)
        }

        if persistentChanges {
            deleteReminder(reminder)
        }

        queue.sync {
            guard let index = reminders.firstIndex(of: reminder) else {
                fatalError("Could not find reminder '\(reminder)' when it was expected to be present")
            }
            reminders.remove(at: index)
        }
    }

    func startReminder(_ reminder: RandomReminder) {
        guard reminder.eponymous else {
            modify(reminder) { reminder in
                reminder.state = .started
            }

            FancyLogger.info("Activating non-random reminder \(reminder)")
            ActiveReminderManager.shared.activateReminder(reminder)
            return
        }

        let reminderActivator = ReminderActivatorService(
            reminder: reminder,
            every: tickInterval,
            onReminderActivation: {
                ActiveReminderManager.shared.activateReminder(reminder)
            },
            onReminderFinished: {
                ActiveReminderManager.shared.deactivateReminder(reminder)
            }
        )

        startedRemindersLock.withLock {
            startedReminders.append(reminderActivator)
        }

        Task.detached(priority: .utility) { [self] in
            let sleepInterval = UInt64(tickInterval.seconds() * 1_000_000_000)
            reminderActivator.running = true
            modify(reminder) { reminder in
                reminder.state = .started
            }

            while reminderActivator.running {
                try? await Task.sleep(nanoseconds: sleepInterval)
                reminderActivator.tick()
            }

            if !reminderActivator.terminated {
                resetReminder(reminder)
            } else {
                FancyLogger.info("Reminder '\(reminder)' will not be restarted")
            }
        }
    }

    func stopReminder(_ reminder: RandomReminder, permanent: Bool = false) {
        guard reminder.eponymous else {
            resetReminder(reminder)
            return
        }

        startedRemindersLock.withLock {
            guard let index = startedReminders.firstIndex(where: { $0.reminder === reminder }) else {
                FancyLogger.warn("Reminder '\(reminder)' was not found when expected to be present")
                return
            }

            let reminderActivator = startedReminders.remove(at: index)
            reminderActivator.running = false
            if permanent {
                reminderActivator.terminated = true
            }
        }
    }

    func resetReminder(_ reminder: RandomReminder) {
        FancyLogger.warn("Finished reminder activator for '\(reminder)'")
        if reminder.hasRepeats {
            FancyLogger.info("Restarted reminder '\(reminder)'")
            modify(reminder) { reminder in
                reminder.advanceToNextRepeat()
            }
        } else {
            FancyLogger.info("Setting '\(reminder)' to past")
            modify(reminder) { reminder in
                reminder.state = .finished
            }
        }
    }

    private func deleteReminder(_ reminder: RandomReminder) {
        let url = StoredReminders.url.appendingPathComponent(reminder.filename())
        do {
            try FileManager.default.removeItem(at: url)
            FancyLogger.info("Deleted reminder file at", url)
        } catch {
            FancyLogger.error("Error removing file:", error)
        }
    }

    private func tick(_ reminder: RandomReminder, on date: Date) {
        guard !ActiveReminderManager.shared.reminderIsActive(reminder) else {
            return
        }

        if !reminder.hasBegun && reminder.hasStarted(after: date) {
            FancyLogger.info("Starting reminder '\(reminder)'")
            startReminder(reminder)
        } else if reminder.hasBegun && reminder.hasEnded(after: date) {
            FancyLogger.info("Stopping reminder '\(reminder)'")
            stopReminder(reminder)
        } else if reminder.hasEnded(after: date) {
            FancyLogger.info("Reminder '\(reminder) will end but has not started")
            resetReminder(reminder)
        }
    }

    @objc
    private func onDayChanged() {
        todaysDay = .today
    }

    private func setReminderStates() {
        // Perform this processing prior to the timer so that we don't
        // start reminders that past before the app launched
        queue.sync {
            let date = Date()
            for reminder in reminders where !reminder.hasPast {
                if reminder.hasEnded(after: date) && !reminder.hasRepeats {
                    FancyLogger.info("Reminder '\(reminder)' set to finished on state initialisation")
                    resetReminder(reminder)
                } else if !reminder.hasBegun && reminder.hasStarted(after: date) {
                    guard remind else {
                        reminder.state = .started
                        continue
                    }
                    assert(reminder.counts.occurences == 0, "Reminder '\(reminder)' should not have occurrences")
                    FancyLogger.info("Starting reminder '\(reminder)' on initialisation")
                    startReminder(reminder)
                }
            }
        }
    }
}
