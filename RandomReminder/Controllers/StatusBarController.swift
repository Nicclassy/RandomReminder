//
//  StatusBarController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import Foundation
import Settings
import SwiftUI

final class StatusBarController {
    private(set) lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private(set) lazy var preferencesViewController = PreferencesViewController()

    init() {
        setup()
    }

    private func setup() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "Menu Bar Icon")
            button.target = self
        }

        statusItem.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.autoenablesItems = false

        let preferencesMenuItem = NSMenuItem(
            title: L10n.StatusBar.preferences,
            action: #selector(openPreferences),
            keyEquivalent: ","
        )
        preferencesMenuItem.target = self
        menu.addItem(preferencesMenuItem)

        let pauseRemindersItem = NSMenuItem(
            title: "Pause all reminders",
            action: #selector(pauseAllReminders),
            keyEquivalent: ""
        )
        pauseRemindersItem.target = self
        pauseRemindersItem.state = SchedulingPreferences.shared.remindersArePaused ? .on : .off
        menu.addItem(pauseRemindersItem)
        menu.addItem(.separator())

        let quitMenuItem = NSMenuItem(
            title: L10n.StatusBar.quit,
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        return menu
    }

    @objc func openPreferences() {
        guard AppPreferences.shared.onboardingComplete else {
            showAlert(
                title: "Onboarding incomplete",
                message: "You must complete the onboarding process prior to using the application.",
                buttonText: "OK"
            )
            return
        }

        preferencesViewController.show()
    }

    @objc func pauseAllReminders() {
        SchedulingPreferences.shared.remindersArePaused.toggle()
        ReminderModificationController.shared.refreshReminders()
    }

    @objc private func quit() {
        NSApp.terminate(self)
    }
}
