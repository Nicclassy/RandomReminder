//
//  View+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 7/7/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func centerWindowOnAppear(activate: Bool = true) -> some View {
        onAppear {
            DispatchQueue.main.async {
                guard let window = NSApp.keyWindow else {
                    FancyLogger.warn("Window was not found when expected")
                    return
                }

                window.center()
                if activate {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    window.makeKeyAndOrderFront(nil)
                }
            }
        }
    }
}
