//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import Foundation
import SwiftUI

final class ReminderManager {
    static let shared = ReminderManager(preview: true)

    private var persistentChanges = false
    private var remind = true

    private var reminders: [RandomReminder]
    private var timerThread: Thread!
    private var tickInterval: ReminderTickInterval = .seconds(1)

    private var startedRemindersQueue = OperationQueue()
    private var remindersQueue = DispatchQueue(
        label: Constants.bundleID + ".ReminderManager.queue",
        qos: .userInitiated
    )

    private let activeRemindersLock = NSLock()
    private let startedRemindersLock = NSLock()
    private var activeReminders: [ActiveReminderService] = []
    private var startedReminders: [ReminderActivatorService] = []

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
                    return nil
                }
                guard reminder.id != .quickReminder else {
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
        setReminderStates()
        guard remind else {
            return
        }

        timerThread = Thread {
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                let date = Date()
                remindersQueue.sync {
                    for reminder in reminders where !reminder.hasPast {
                        if reminder.hasEnded(after: date) {
                            FancyLogger.info("Reminder '\(reminder)' has ended after \(date)")
                            stopReminder(reminder)
                        } else if !reminder.hasBegun && reminder.hasStarted(after: date) {
                            FancyLogger.info("Starting reminder '\(reminder)'")
                            startReminder(reminder)
                        }
                    }
                }
            }
            RunLoop.current.add(timer, forMode: .default)
            RunLoop.current.run()
        }
        timerThread.start()
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

    func nextAvailableId() -> ReminderID {
        (.first...).first { !reminderIds.contains($0) }!
    }

    func addReminder(_ reminder: RandomReminder) {
        remindersQueue.sync {
            reminders.append(reminder)
        }
        if persistentChanges {
            ReminderSerializer.save(reminder, filename: reminder.filename())
        }
    }

    func removeReminder(_ reminder: RandomReminder) {
        remindersQueue.sync {
            guard let index = reminders.firstIndex(of: reminder) else {
                fatalError("Could not find reminder '\(reminder)' when it was expected to be present")
            }
            _ = reminders.remove(at: index)
        }
        stopReminder(reminder)
        if persistentChanges {
            deleteReminder(reminder)
        }
    }

    func activateReminder(_ reminder: RandomReminder) {
        if let activeReminder = activeReminders.first(where: { $0.reminder === reminder }) {
            NotificationManager.shared.addReminderNotification(for: activeReminder)
        } else {
            let activeReminder = ActiveReminderService(reminder: reminder)
            activeRemindersLock.withLock {
                activeReminders.append(activeReminder)
            }
            NotificationManager.shared.addReminderNotification(for: activeReminder)
        }
    }

    func deactivateReminder(_ reminder: RandomReminder) {
        activeRemindersLock.withLock {
            guard let index = activeReminders.firstIndex(where: { $0.reminder === reminder }) else {
                FancyLogger.warn("Reminder '\(reminder)' is not in the active reminders list when it should be")
                return
            }

            activeReminders.remove(at: index)
            FancyLogger.info("Deactivated reminder '\(reminder)'")
        }
    }

    func startReminder(_ reminder: RandomReminder) {
        let reminderActivator = ReminderActivatorService(reminder: reminder, every: tickInterval) { [self] in
            activateReminder(reminder)
            if reminder.counts.occurenceIsFinal {
                stopReminder(reminder)
            }
        }

        startedRemindersLock.withLock {
            startedReminders.append(reminderActivator)
        }

        startedRemindersQueue.addOperation { [self] in
            let sleepInterval = tickInterval.seconds()
            reminderActivator.start()
            while reminderActivator.running {
                Thread.sleep(forTimeInterval: sleepInterval)
                reminderActivator.tick()
            }

            FancyLogger.info("Finished reminder '\(reminder)'")
        }
    }

    func stopReminder(_ reminder: RandomReminder) {
        startedRemindersLock.withLock {
            guard let index = startedReminders.firstIndex(where: { $0.reminder === reminder }) else {
                FancyLogger.warn("Reminder '\(reminder)' was not found when it should be present")
                return
            }

            startedReminders.remove(at: index)
            deactivateReminder(reminder)
        }
    }

    private func deleteReminder(_ reminder: RandomReminder) {
        let url = StoredReminders.url.appendingPathComponent(reminder.filename())
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            FancyLogger.error("Error removing file:", error)
        }
    }

    private func setReminderStates() {
        // Perform this processing prior to the timer so that we don't
        // start reminders that past before the app launched
        remindersQueue.sync {
            let date = Date()
            reminders.forEach { [self] reminder in
                if !reminder.hasPast && reminder.hasEnded(after: date) {
                    FancyLogger.info("Reminder '\(reminder)' set to finished on state initialisation")
                    reminder.state = .finished
                } else if reminder.hasStarted(after: date) {
                    guard remind else {
                        reminder.state = .started
                        return
                    }
                    assert(reminder.counts.occurences == 0, "Reminder '\(reminder)' should not have occurrences")
                    FancyLogger.info("Starting reminder '\(reminder)' on initialisation")
                    startReminder(reminder)
                }
            }
        }
    }
}
