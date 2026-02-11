//
//  AppDelegate.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        StatusBarController.shared.setup()
        OnboardingManager.shared.setup()
        ReminderManager.setup()
    }

    func applicationShouldHandleReopen(_: NSApplication, _: Bool) -> Bool {
        StatusBarController.shared.openPreferences()
        FancyLogger.info("Reopening preferences")
        return false
    }

    func applicationDidBecomeActive(_: Notification) {
        if !isPreview {
            FancyLogger.info("Application became active")
        }
    }
}
