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
    @Published var modificationWindowOpen = false
    var openedModificationWindow = false
    weak var reminder: RandomReminder?

    func postRefreshRemindersNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .refreshReminders, object: nil)
        }
    }
    
    func isEditingReminder(_ reminder: RandomReminder) -> Bool {
        self.reminder == reminder
    }
}
