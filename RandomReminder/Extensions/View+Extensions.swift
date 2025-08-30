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

    func centerWindowOnAppear(withTitle title: String? = nil, activate: Bool = true) -> some View {
        onAppear {
            DispatchQueue.main.async {
                let window = if let title {
                    NSApplication.shared.windows.first(where: { $0.title == title })
                } else {
                    NSApplication.shared.keyWindow
                }
                guard let window else {
                    FancyLogger.warn("Window with title \(title ?? "(n/a)") was not found when expected")
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
