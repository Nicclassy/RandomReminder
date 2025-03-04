//
//  ReminderWindowController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/2/2025.
//

import SwiftUI

final class ReminderWindowController {
    static let shared = ReminderWindowController()
    
    private var reminderCreationWindow: ReminderModificationWindow!
    private var reminderEditWindow: ReminderModificationWindow!
    
    func openCreateWindow() {
        reminderCreationWindow = ReminderModificationWindow(title: "Create reminder", mode: .create)
        reminderCreationWindow.show()
    }
    
    func openEditWindow(for reminder: RandomReminder) {
        reminderEditWindow = ReminderModificationWindow(title: "Edit reminder", mode: .edit)
        reminderEditWindow.show()
    }
    
    func closeCreationWindow() {
        reminderCreationWindow.close()
    }
    
    func closeEditWindow() {
        reminderEditWindow.close()
    }
}
