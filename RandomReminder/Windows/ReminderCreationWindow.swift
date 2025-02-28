//
//  ReminderCreationWindow.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/2/2025.
//

import SwiftUI

final class ReminderCreationWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 430),
            styleMask: [.closable, .titled, .resizable],
            backing: .buffered,
            defer: false
        )
        
        title = "Create New Reminder"
        level = .floating
        contentView = NSHostingView(rootView: ReminderCreationView())
    }
    
    func show() {
        center()
        makeKeyAndOrderFront(nil)
    }
}
