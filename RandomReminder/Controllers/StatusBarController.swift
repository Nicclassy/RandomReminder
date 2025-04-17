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
    lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    lazy var preferencesViewController = PreferencesViewController()
    weak var quickReminderItem: NSMenuItem!

    init() {
        setupView()
    }

    private func setupView() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "Menu Bar Icon")
            button.target = self
            button.action = #selector(onStatusBarClick)
        }

        statusItem.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.autoenablesItems = false

        let quickReminderView = QuickReminderView()
        let controller = NSHostingController(rootView: quickReminderView)
        controller.view.frame.size = CGSize(width: 200, height: 100)

        let quickReminderItem = NSMenuItem()
        quickReminderItem.view = controller.view
        quickReminderItem.isHidden = !AppPreferences.shared.quickReminderEnabled
        menu.addItem(quickReminderItem)
        menu.addItem(.separator())
        self.quickReminderItem = quickReminderItem

        let preferencesMenuItem = NSMenuItem(
            title: L10n.StatusBar.preferences,
            action: #selector(openPreferences),
            keyEquivalent: ","
        )
        preferencesMenuItem.target = self
        menu.addItem(preferencesMenuItem)
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

    @objc
    private func onStatusBarClick() {
        FancyLogger.info("Status bar item clicked")
    }

    @objc
    private func openPreferences() {
        preferencesViewController.show()
    }

    @objc
    private func quit() {
        NSApp.terminate(self)
    }
}
