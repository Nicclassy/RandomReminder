//
//  SchedulingPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 27/3/2025.
//

import SwiftUI

final class SchedulingPreferences: ObservableObject {
    static let shared = SchedulingPreferences()

    @AppStorage("defaultReminderTimesMode") var defaultReminderTimesMode: DefaultReminderTimesMode = .exact
    @AppStorage("defaultEarliestTime") var defaultEarliestTime: TimeInterval = 0
    @AppStorage("defaultLatestTime") var defaultLatestTime: TimeInterval = 0

    @AppStorage("earliestOffsetQuantity") var earliestOffsetQuantity = 0
    @AppStorage("earliestOffsetTimeUnit") var earliestOffsetTimeUnit: TimeUnit = .minute
    @AppStorage("latestOffsetQuantity") var latestOffsetQuantity = 0
    @AppStorage("latestOffsetTimeUnit") var latestOffsetTimeUnit: TimeUnit = .minute

    @AppStorage("notificationGapEnabled") var notificationGapEnabled = false
    @AppStorage("notificationGapTime") var notificationGapTime = 0
    @AppStorage("notificationGapTimeUnit") var notificationGapTimeUnit: TimeUnit = .second

    @AppStorage("notificationAutoDismissEnabled") var notificationAutoDismissEnabled = false
    @AppStorage("notificationAutoDismissTime") var notificationAutoDismissTime = 0
    @AppStorage("notificationAutoDismissTimeUnit") var notificationAutoDismissTimeUnit: TimeUnit = .second

    @AppStorage("remindersArePaused") var remindersArePaused = false

    private init() {}
}
