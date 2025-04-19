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
    var editingReminder = false
    var creatingReminder = false
    weak var reminder: RandomReminder?

    func canCreateOrEditReminders() -> Bool {
        !editingReminder && !creatingReminder
    }

    func stopEditingReminder() {
        editingReminder = false
        reminder = nil
    }

    func stopCreatingReminder() {
        creatingReminder = false
        reminder = nil
    }
}
