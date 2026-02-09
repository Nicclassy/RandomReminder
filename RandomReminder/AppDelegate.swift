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

    func applicationDidBecomeActive(_: Notification) {
        if !isPreview {
            FancyLogger.info("Application became active")
        }
    }
}
