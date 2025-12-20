//
//  AppDelegate.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private(set) static var shared: AppDelegate!
    private(set) var statusBarController: StatusBarController!

    func applicationDidFinishLaunching(_: Notification) {
        AppPreferences.shared.onboardingComplete = true
        Self.shared = self
        statusBarController = .init()
        ReminderManager.shared.setup()
        if AppPreferences.shared.onboardingComplete {
            NotificationPermissions.shared.promptIfAlertsNotEnabled()
        }
    }

    func applicationDidBecomeActive(_: Notification) {
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }

    func onOnboardingCompletion() {
        AppPreferences.shared.onboardingComplete = true
    }
}
