//
//  PreferencesViewController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 30/12/2024.
//

import Foundation
import SwiftUI
import Settings

final class PreferencesViewController {
    private let windowController: SettingsWindowController
    
    let GeneralPreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .general,
                title: "General",
                toolbarIcon: NSImage(systemSymbolName: "gear", accessibilityDescription: "General Preferences")!
            ) {
                GeneralPreferencesView()
            }
        )
    }
    
    let RemindersPreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .reminders,
                title: "Reminders",
                toolbarIcon: NSImage(systemSymbolName: "clock.badge.exclamationmark", accessibilityDescription: "Reminder Preferences")!
            ) {
                RemindersPreferencesView()
            }
        )
    }
    
    let AboutPreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .about,
                title: "About",
                toolbarIcon: NSImage(systemSymbolName: "info.circle", accessibilityDescription: "About Preferences")!
            ) {
                AboutPreferencesView()
            }
        )
    }
    
    init() {
        self.windowController = SettingsWindowController(
            panes: [
                GeneralPreferencesViewController(),
                RemindersPreferencesViewController(),
                AboutPreferencesViewController()
            ],
            style: .toolbarItems,
            animated: false,
            hidesToolbarForSingleItem: false
        )
    }
    
    func show() {
        self.windowController.show()
    }
}
