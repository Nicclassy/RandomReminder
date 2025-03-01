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
    private lazy var windowController: SettingsWindowController = {
        SettingsWindowController(
            panes: [
                GeneralPreferencesViewController(),
                SchedulePreferencesViewController(),
                RemindersPreferencesViewController(),
                AboutPreferencesViewController()
            ],
            style: .toolbarItems,
            animated: true,
            hidesToolbarForSingleItem: false
        )
    }()
    
    let GeneralPreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .general,
                title: "General",
                toolbarIcon: NSImage(
                    systemSymbolName: "gear",
                    accessibilityDescription: "General Preferences"
                )!
            ) {
                GeneralPreferencesView()
            }
        )
    }
    
    let SchedulePreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .schedule,
                title: "Schedule",
                toolbarIcon: NSImage(
                    systemSymbolName: "timer",
                    accessibilityDescription: "Schedule Preferences"
                )!
            ) {
                SchedulePreferencesView()
            }
        )
    }
    
    let RemindersPreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .reminders,
                title: "Reminders",
                toolbarIcon: NSImage(
                    systemSymbolName: "calendar.badge.exclamationmark",
                    accessibilityDescription: "Reminder Preferences"
                )!
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
                toolbarIcon: NSImage(
                    systemSymbolName: "info.circle",
                    accessibilityDescription: "About Preferences"
                )!
            ) {
                AboutPreferencesView()
            }
        )
    }
    
    func show() {
        self.windowController.show()
        self.windowController.window?.center()
    }
}
