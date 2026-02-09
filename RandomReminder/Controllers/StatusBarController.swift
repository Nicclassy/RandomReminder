//
//  StatusBarController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import Settings
import SwiftUI

final class StatusBarController: NSObject {
    static let shared = StatusBarController()

    private(set) lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private(set) lazy var preferencesViewController = PreferencesViewController()
    private weak var pauseRemindersItem: NSMenuItem?

    func setup() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "Menu Bar Icon")
            button.target = self
        }

        statusItem.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.delegate = self

        let preferencesMenuItem = NSMenuItem(
            title: L10n.StatusBar.preferences,
            action: #selector(openReminderPreferences),
            keyEquivalent: ","
        )
        preferencesMenuItem.target = self
        menu.addItem(preferencesMenuItem)

        let pauseRemindersItem = NSMenuItem(
            title: "",
            action: #selector(togglePauseAllReminders),
            keyEquivalent: ""
        )
        pauseRemindersItem.target = self
        menu.addItem(pauseRemindersItem)
        self.pauseRemindersItem = pauseRemindersItem
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

    private func updatePauseMenuItem() {
        guard let pauseRemindersItem else {
            fatalError("Pause reminders item not set")
        }

        let isEnabled = SchedulingPreferences.shared.remindersArePaused
        pauseRemindersItem.title = isEnabled ? "Unpause all reminders" : "Pause all reminders"
    }

    @objc func openReminderPreferences() {
        guard OnboardingManager.shared.onboardingIsComplete else {
            showAlert(
                title: "Onboarding incomplete",
                message: "You must complete the onboarding process prior to using the application.",
                buttonText: "OK"
            )
            return
        }

        preferencesViewController.show()
        ReminderModificationController.shared.updateReminderText()
    }

    @objc private func togglePauseAllReminders() {
        SchedulingPreferences.shared.remindersArePaused.toggle()
        updatePauseMenuItem()
        ReminderModificationController.shared.updateReminderText()
    }

    @objc private func quit() {
        NSApp.terminate(self)
    }
}

extension StatusBarController: NSMenuDelegate {
    func menuWillOpen(_: NSMenu) {
        updatePauseMenuItem()
    }
}
