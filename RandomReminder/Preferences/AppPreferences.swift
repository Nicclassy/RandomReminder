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

    @AppStorage("launchAtLogin") var launchAtLogin = false
    @AppStorage("showReminderCounts") var showReminderCounts = true
    @AppStorage("quickReminderEnabled") var quickReminderEnabled = true
    @AppStorage("quickReminderStarted") var quickReminderStarted = false
    @AppStorage("randomiseAudioPlaybackStart") var randomiseAudioPlaybackStart = true

    private init() {}
}
