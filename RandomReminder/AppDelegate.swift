//
//  AppDelegate.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import Foundation
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private(set) static var shared: AppDelegate!
    private(set) var statusBarController: StatusBarController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self
        statusBarController = .init()
        ReminderManager.shared.setup()
    }
    
    func setQuickReminderEnabled(enabled: Bool) {
        statusBarController.quickReminderItem.isHidden = !enabled
    }
}
