//
//  ReminderModificationController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/4/2025.
//

import Foundation

final class ReminderModificationController: ObservableObject {
    static let shared = ReminderModificationController()

    @Published var refreshReminders = false
    @Published var refreshModificationWindow = false
    @Published var modificationWindowOpen = false
    weak var reminder: RandomReminder?

    func postRefreshRemindersNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .refreshReminders, object: nil)
        }
    }

    func postRefreshModificationWindowNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .refreshModificationWindow, object: nil)
        }
    }

    func isEditingReminder(with id: ReminderID) -> Bool {
        if let reminder, reminder.id == id {
            true
        } else {
            false
        }
    }
}
