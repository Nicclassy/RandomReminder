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
        Self.shared = self
        statusBarController = .init()
        ReminderManager.setup()
    }

    func applicationDidBecomeActive(_: Notification) {
        if let window = NSApp.windows.first {
            window.makeKeyAndOrderFront(nil)
        }
    }

    func openReminderPreferences() {
        statusBarController.preferencesViewController.show()
        ReminderModificationController.shared.refreshReminders()
    }
}
