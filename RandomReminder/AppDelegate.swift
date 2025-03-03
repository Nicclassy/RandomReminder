//
//  AppDelegate.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import Foundation
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    static private(set) var shared: AppDelegate!
    var statusBarController: StatusBarController!
    
    private lazy var reminderCreationWindow = ReminderModificationWindow()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        statusBarController = .init()
    }
    
    func toggleQuickReminder(isEnabled: Bool) {
        statusBarController.quickReminderItem.isHidden = !isEnabled
    }
    
    func openReminderCreationWindow(mode: ReminderModificationMode) {
        NSApp.activate()
        reminderCreationWindow.show(mode: mode)
    }
}
