//
//  StatusBarController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import Foundation
import SwiftUI

final class StatusBarController {
    lazy var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    weak var preferencesWindow: NSWindow!
    
    init() {
        setupView()
    }
    
    private func setupView() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "Menu Bar Icon")
            // Self Implements action of the button
            button.target = self
            button.action = #selector(onStatusBarClick)
        }
        statusItem.menu = buildMenu()
    }
    
    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        let preferencesMenuItem = NSMenuItem(
            title: "Preferences",
            action: #selector(openPreferences),
            keyEquivalent: ","
        )
        preferencesMenuItem.target = self
        menu.addItem(preferencesMenuItem)
        menu.addItem(.separator())
        
        let quitMenuItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        return menu
    }
    
    private func createPreferencesWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 430),
            styleMask: [.closable, .titled, .resizable],
            backing: .buffered,
            defer: false
        )
        let contentView = PreferencesView()
        window.title = "Preferences"
        window.level = .floating
        window.contentView = NSHostingView(rootView: contentView)
        
        let controller = NSWindowController(window: window)
        controller.showWindow(self)
        
        window.center()
        window.orderFrontRegardless()
        return window
    }
    
    @objc private func onStatusBarClick() {}
    
    @objc private func openPreferences() {
        preferencesWindow ??= createPreferencesWindow()
        NSApp.activate()
        preferencesWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc private func quit() {
        NSApp.terminate(self)
    }
}
