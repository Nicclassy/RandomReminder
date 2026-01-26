//
//  ReminderModificationController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/4/2025.
//

import Foundation

final class ReminderModificationController: ObservableObject {
    static let shared = ReminderModificationController()

    @Published var modificationWindowOpen = false
    @Published var refreshToggle = false
    weak var reminder: RandomReminder?

    func refreshReminders() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .refreshReminders, object: nil)
        }
    }

    func refreshModificationWindow() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .refreshModificationWindow, object: nil)
        }
    }

    func isEditingReminder(with id: ReminderID) -> Bool {
        reminder?.id == id
    }
}
