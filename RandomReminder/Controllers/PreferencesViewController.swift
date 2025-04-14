//
//  PreferencesViewController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 30/12/2024.
//

import SwiftUI
import Settings

// swiftlint:disable identifier_name
final class PreferencesViewController {
    private lazy var windowController: SettingsWindowController = {
        SettingsWindowController(
            panes: [
                GeneralPreferencesViewController(),
                SchedulingPreferencesViewController(),
                RemindersPreferencesViewController(),
                AboutPreferencesViewController()
            ],
            style: .toolbarItems,
            animated: true,
            hidesToolbarForSingleItem: false
        )
    }()
    
    private let GeneralPreferencesViewController: () -> SettingsPane = {
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
    
    private let SchedulingPreferencesViewController: () -> SettingsPane = {
        Settings.PaneHostingController(
            pane: Settings.Pane(
                identifier: .scheduling,
                title: "Scheduling",
                toolbarIcon: NSImage(
                    systemSymbolName: "timer",
                    accessibilityDescription: "Scheduling Preferences"
                )!
            ) {
                SchedulingPreferencesView()
            }
        )
    }
    
    private let RemindersPreferencesViewController: () -> SettingsPane = {
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
                    .assignToController()
            }
        )
    }
    
    private let AboutPreferencesViewController: () -> SettingsPane = {
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
        windowController.show()
        windowController.window?.center()
    }
}
// swiftlint:enable identifier_name
