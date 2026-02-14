//
//  ActiveReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 1/8/2025.
//

import Foundation

final class ActiveReminderManager {
    static let shared = ActiveReminderManager()

    private let queue = DispatchQueue(
        label: Constants.bundleID + ".ActiveReminderManager.queue",
        qos: .userInitiated
    )

    var activeReminderNotification: ReminderNotification!
    var activeReminderDescription: String!
    private var activeReminders: [ActiveReminderService] = []
    private var queuedReminders: [RandomReminder] = []

    private init() {}

    func reminderIsActive(_ reminder: RandomReminder) -> Bool {
        reminder == activeReminderNotification?.reminder
    }

    func reminderIsWaiting(_ reminder: RandomReminder) -> Bool {
        queuedReminders.contains(reminder)
    }

    func enqueueReminder(_ reminder: RandomReminder) {
        queuedReminders.append(reminder)
    }

    func dequeueReminder(_ reminder: RandomReminder) {
        guard let index = queuedReminders.firstIndex(of: reminder) else {
            fatalError("Reminder \(reminder) not found in queue")
        }

        queuedReminders.remove(at: index)
    }

    func setActiveReminder(with notification: ReminderNotification) {
        self.activeReminderNotification = notification
    }

    func unsetActiveReminder() {
        activeReminderNotification = nil
    }

    func activateReminder(_ reminder: RandomReminder) {
        if let activeReminder = activeReminders.first(where: { $0.reminder === reminder }) {
            NotificationManager.shared.addReminderNotification(for: activeReminder)
            return
        }

        let activeReminder = ActiveReminderService(reminder: reminder)
        queue.sync {
            activeReminders.append(activeReminder)
        }
        NotificationManager.shared.addReminderNotification(for: activeReminder)
    }

    func deactivateReminder(_ reminder: RandomReminder) {
        queue.sync {
            guard let index = activeReminders.firstIndex(where: { $0.reminder === reminder }) else {
                FancyLogger.warn("Reminder '\(reminder)' is not present in the active reminders list when expected")
                return
            }

            activeReminders.remove(at: index)
            FancyLogger.warn("Deactivated reminder '\(reminder)'")
        }
    }
}
