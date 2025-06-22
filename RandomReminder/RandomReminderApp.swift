//
//  RandomReminderApp.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/12/2024.
//

import SwiftUI

@main
struct RandomReminderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .defaultLaunchBehavior(.suppressed)

        Window("Create New Reminder", id: WindowIds.createReminder) {
            ReminderModificationView(mode: .create)
        }
        .windowResizability(.contentSize)

        Window("Edit Reminder", id: WindowIds.editReminder) {
            ReminderModificationView(mode: .edit)
        }
        .windowResizability(.contentSize)

        Window("Description Command", id: WindowIds.descriptionCommand) {
            ReminderDescriptionView()
        }
        .windowResizability(.contentSize)
    }
}
