//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import SwiftUI

final class ReminderManager {
    static let shared = ReminderManager(preview: true)

    private let remind = true
    private let persistentChanges = false

    private var reminders: [RandomReminder]
    private var timerThread: Thread!
    private var tickInterval: ReminderTickInterval = .seconds(1)

    private var remindersQueue = DispatchQueue(
        label: Constants.bundleID + ".ReminderManager.queue",
        qos: .userInitiated
    )

    private let activeRemindersLock = NSLock()
    private let startedRemindersLock = NSLock()
    private var activeReminders: [ActiveReminderService] = []
    private var startedReminders: [ReminderActivatorService] = []

    var todaysDay: ReminderDayOptions = .today

    var reminderIds: Set<ReminderID> {
        remindersQueue.sync {
            Set(reminders.map(\.id))
        }
    }

    var audioFiles: [ReminderAudioFile] {
        remindersQueue.sync {
            reminders.compactMap(\.activationEvents.audio)
        }
    }

    init(_ reminders: [RandomReminder]) {
        self.reminders = reminders
    }

    convenience init(preview: Bool = false) {
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
                remindersQueue.sync {
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

    func onReminderChange(of reminder: RandomReminder) {
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

        guard reminder.days.contains(todaysDay) else {
            return false
        }

        return true
    }

    func reminderExists(_ reminder: RandomReminder) -> Bool {
        remindersQueue.sync {
            reminders.lazy.contains(reminder)
        }
    }

    func upcomingReminders() -> [RandomReminder] {
        remindersQueue.sync {
            reminders.lazy.filter { !$0.hasPast }.sorted { $0.compare(with: $1) }
        }
    }

    func pastReminders() -> [RandomReminder] {
        remindersQueue.sync {
            reminders.lazy.filter { $0.hasPast }.sorted { $0.compare(with: $1) }
        }
    }

    func reminderWithSameTitleExists(as title: String) -> Bool {
        remindersQueue.sync {
            reminders.lazy.contains { $0.content.title == title }
        }
    }

    func nextAvailableId() -> ReminderID {
        (.first...).first { !reminderIds.map(\.value).contains($0.value) }!
    }

    func addReminder(_ reminder: RandomReminder) {
        remindersQueue.sync {
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
            deactivateReminder(reminder)
        }

        if persistentChanges {
            deleteReminder(reminder)
        }

        remindersQueue.sync {
            guard let index = reminders.firstIndex(of: reminder) else {
                fatalError("Could not find reminder '\(reminder)' when it was expected to be present")
            }
            reminders.remove(at: index)
        }
    }

    func activateReminder(_ reminder: RandomReminder) {
        if let activeReminder = activeReminders.first(where: { $0.reminder === reminder }) {
            NotificationManager.shared.addReminderNotification(for: activeReminder)
            return
        }

        let activeReminder = ActiveReminderService(reminder: reminder)
        activeRemindersLock.withLock {
            activeReminders.append(activeReminder)
        }
        NotificationManager.shared.addReminderNotification(for: activeReminder)
    }

    func deactivateReminder(_ reminder: RandomReminder) {
        activeRemindersLock.withLock {
            guard let index = activeReminders.firstIndex(where: { $0.reminder === reminder }) else {
                FancyLogger.warn("Reminder '\(reminder)' not found in active list")
                return
            }

            activeReminders.remove(at: index)
            FancyLogger.warn("Deactivated reminder '\(reminder)'")
        }
    }

    func startReminder(_ reminder: RandomReminder) {
        let reminderActivator = ReminderActivatorService(
            reminder: reminder,
            every: tickInterval,
            onReminderActivation: { [self] in
                activateReminder(reminder)
            },
            onReminderFinished: { [self] in
                deactivateReminder(reminder)
            }
        )

        startedRemindersLock.withLock {
            startedReminders.append(reminderActivator)
        }

        Task.detached(priority: .utility) { [self] in
            let sleepInterval = UInt64(tickInterval.seconds() * 1_000_000_000)
            reminderActivator.running = true
            // Reminder mutations
            reminder.state = .started
            onReminderChange(of: reminder)

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
        // Reminder mutations
        FancyLogger.warn("Finished reminder activator for '\(reminder)'")
        if reminder.hasRepeats {
            FancyLogger.info("Restarted reminder '\(reminder)'")
            reminder.advanceToNextRepeat()
            onReminderChange(of: reminder)
        } else {
            FancyLogger.info("Setting '\(reminder)' to past")
            reminder.state = .finished
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
        remindersQueue.sync {
            let date = Date()
            for reminder in reminders where !reminder.hasPast {
                if reminder.hasEnded(after: date) && !reminder.hasRepeats {
                    FancyLogger.info("Reminder '\(reminder)' set to finished on state initialisation")
                    // Reminder mutations
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
