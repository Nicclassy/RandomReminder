//
//  ActiveReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 1/8/2025.
//

import Foundation

final class ActiveReminderManager {
    static let shared = ActiveReminderManager()

    private let lock = NSLock()
    private var activeReminders: [ActiveReminderService] = []

    private init() {}

    func activateReminder(_ reminder: RandomReminder) {
        if let activeReminder = activeReminders.first(where: { $0.reminder === reminder }) {
            NotificationManager.shared.addReminderNotification(for: activeReminder)
            return
        }

        let activeReminder = ActiveReminderService(reminder: reminder)
        lock.withLock {
            activeReminders.append(activeReminder)
        }
        NotificationManager.shared.addReminderNotification(for: activeReminder)
    }

    func deactivateReminder(_ reminder: RandomReminder) {
        lock.withLock {
            guard let index = activeReminders.firstIndex(where: { $0.reminder === reminder }) else {
                FancyLogger.warn("Reminder '\(reminder)' is not present in the active reminders list")
                return
            }

            activeReminders.remove(at: index)
            FancyLogger.warn("Deactivated reminder '\(reminder)'")
        }
    }
}
