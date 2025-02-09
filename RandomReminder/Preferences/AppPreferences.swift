//
//  AppPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation
import SwiftUI

enum Keys {
    static let launchAtLogin = "launchAtLogin"
    static let quickReminderEnabled = "quickReminderEnabled"
    static let quickReminderStarted = "quickReminderStarted"
    static let defaultEarliestTime = "defaultEarliestTime"
    static let defaultLatestTime = "defaultLatestTime"
}

final class AppPreferences: ObservableObject {
    static let shared = AppPreferences()
    
    private init() {}
    
    @AppStorage(Keys.launchAtLogin) var launchAtLogin = false
    @AppStorage(Keys.quickReminderEnabled) var quickReminderEnabled = true
    @AppStorage(Keys.quickReminderStarted) var quickReminderStarted = false
    @AppStorage(Keys.defaultEarliestTime) var defaultEarliestTime: TimeInterval = 0
    @AppStorage(Keys.defaultLatestTime) var defaultLatestTime: TimeInterval = 0
}
