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

    var activeReminder: RandomReminder!
    var activeReminderDescription: String!
    private var activeReminders: [ActiveReminderService] = []

    private init() {}

    func reminderIsActive(_ reminder: RandomReminder) -> Bool {
        reminder == Self.shared.activeReminder
    }

    func setActiveReminder(_ reminder: RandomReminder, with description: String) {
        activeReminder = reminder
        activeReminderDescription = description
    }

    func unsetActiveReminder() {
        activeReminder = nil
        activeReminderDescription = nil
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
