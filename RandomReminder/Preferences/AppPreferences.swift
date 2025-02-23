//
//  AppPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation
import SwiftUI

final class AppPreferences: ObservableObject {
    static let shared = AppPreferences()
    
    private init() {}
    
    @AppStorage("launchAtLogin") var launchAtLogin = false
    @AppStorage("quickReminderEnabled") var quickReminderEnabled = true
    @AppStorage("quickReminderStarted") var quickReminderStarted = false
    @AppStorage("defaultEarliestTime") var defaultEarliestTime: TimeInterval = 0
    @AppStorage("defaultLatestTime") var defaultLatestTime: TimeInterval = 0
}
