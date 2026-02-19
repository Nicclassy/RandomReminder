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

    var activeReminderNotification: ReminderNotification! {
        didSet {
            ReminderModificationController.shared.updateReminderText()
        }
    }

    private var activeReminders: [ActiveReminderService] = []
    private var waitingReminderIds: Set<ReminderID> = []

    private init() {}

    func reminderIsActive(_ reminder: RandomReminder) -> Bool {
        reminder == activeReminderNotification?.reminder
    }

    func reminderIsWaiting(_ reminder: RandomReminder) -> Bool {
        queue.sync {
            waitingReminderIds.contains(reminder.id)
        }
    }

    func markAsWaiting(_ reminder: RandomReminder) {
        queue.sync {
            _ = waitingReminderIds.insert(reminder.id)
        }
        ReminderModificationController.shared.updateReminderText()
    }

    func removeWaiting(_ reminder: RandomReminder) {
        queue.sync {
            _ = waitingReminderIds.remove(reminder.id)
        }
        ReminderModificationController.shared.updateReminderText()
    }

    func setActiveReminder(with notification: ReminderNotification) {
        activeReminderNotification = notification
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
