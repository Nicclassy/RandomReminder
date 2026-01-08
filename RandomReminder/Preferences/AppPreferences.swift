//
//  AppPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import SwiftUI

final class AppPreferences: ObservableObject {
    static let shared = AppPreferences()

    @AppStorage("onboardingComplete") var onboardingComplete = false
    @AppStorage("launchAtLogin") var launchAtLogin = false
    @AppStorage("singleModificationView") var singleModificationView = true
    @AppStorage("showReminderCounts") var showReminderCounts = true
    @AppStorage("quickReminderEnabled") var quickReminderEnabled = true
    @AppStorage("quickReminderStarted") var quickReminderStarted = false
    @AppStorage("randomiseAudioPlaybackStart") var randomiseAudioPlaybackStart = true
    @AppStorage("timeFormat") var timeFormat: TimeFormat = .long
    @AppStorage("allowBanners") var allowBanners = false

    private init() {}
}
