//
//  ReminderModificationWindow.swift
//  RandomReminder
//
//  Created by Luca Napoli on 4/3/2025.
//

import SwiftUI

final class ReminderModificationWindow: NSWindow {
    init(reminder: RandomReminder? = nil, title: String, mode: ReminderModificationMode) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 430),
            styleMask: [.closable, .titled, .resizable],
            backing: .buffered,
            defer: false
        )
        self.title = title
        
        let rootView = ReminderModificationView(
            reminder: reminder == nil ? ReminderBuilder() : ReminderBuilder(from: reminder!),
            preferences: ReminderPreferences(),
            mode: mode
        )
        isReleasedWhenClosed = true
        level = .floating
        contentView = NSHostingView(rootView: rootView)
    }
    
    func show() {
        center()
        makeKeyAndOrderFront(nil)
    }
}
