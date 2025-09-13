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
        Window(WindowTitles.onboarding, id: WindowIds.onboarding) {
            OnboardingView(onCompletion: appDelegate.onOnboardingCompletion)
        }
        .defaultLaunchBehavior(AppPreferences.shared.onboardingComplete ? .suppressed : .automatic)
        .windowResizability(.contentSize)

        Window(WindowTitles.createReminder, id: WindowIds.createReminder) {
            ReminderModificationView(mode: .create)
        }
        .windowResizability(.contentSize)

        Window(WindowTitles.editReminder, id: WindowIds.editReminder) {
            ReminderModificationView(mode: .edit)
        }
        .windowResizability(.contentSize)

        Window(WindowTitles.descriptionCommand, id: WindowIds.descriptionCommand) {
            ReminderDescriptionView()
        }
        .windowResizability(.contentSize)

        Window(WindowTitles.activeReminder, id: WindowIds.activeReminder) {
            ActiveReminderView()
        }
        .windowResizability(.contentSize)
    }
}
