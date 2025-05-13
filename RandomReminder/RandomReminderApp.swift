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
            ReminderModificationView(reminder: .init(), preferences: .init(), mode: .create)
        }
        .windowResizability(.contentSize)

        Window("Edit Reminder", id: WindowIds.editReminder) {
            let controller = ReminderModificationController.shared
            ReminderModificationView(
                reminder: MutableReminder(from: controller.reminder!),
                preferences: ReminderPreferences(from: controller.reminder!),
                mode: .edit
            )
        }
        .windowResizability(.contentSize)
    }
}
