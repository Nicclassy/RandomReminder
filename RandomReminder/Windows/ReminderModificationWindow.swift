//
//  ReminderCreationWindow.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/2/2025.
//

import SwiftUI

final class ReminderModificationWindow: NSWindow {
    lazy var rootView = ReminderModificationView()
    
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 430),
            styleMask: [.closable, .titled, .resizable],
            backing: .buffered,
            defer: false
        )
        
        title = "Create New Reminder"
        level = .floating
        contentView = NSHostingView(rootView: rootView)
    }
    
    func show(mode: ReminderModificationMode) {
        rootView.mode = mode
        center()
        makeKeyAndOrderFront(nil)
    }
}
