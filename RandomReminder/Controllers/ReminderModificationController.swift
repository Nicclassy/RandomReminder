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
    var descriptionCommand: ReminderDescription = .command("", generatesTitle: false)
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

    func setDescriptionCommand(_ command: ReminderDescription) {
        descriptionCommand = command
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .descriptionCommandSet, object: nil)
        }
    }

    func editDescriptionCommand(_ command: ReminderDescription) {
        descriptionCommand = command
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .editDescriptionCommand, object: nil)
        }
    }

    func isEditingReminder(with id: ReminderID) -> Bool {
        reminder?.id == id
    }
}
