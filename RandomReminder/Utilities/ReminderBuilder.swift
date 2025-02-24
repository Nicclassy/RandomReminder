//
//  ReminderBuilder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation

final class ReminderBuilder: ObservableObject {
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var totalReminders: Int = 0
    @Published var earliestDate: Date = Date()
    @Published var latestDate: Date = Date().addMinutes(60)
    @Published var days: ReminderDayOptions = []
    @Published var repeatInterval: RepeatInterval = .minute
    @Published var activationEvents: ReminderActivationEvents = .init()
    
    init() {}
    
    func build(preferences reminderPreferences: ReminderPreferences) -> RandomReminder {
        let reminderInterval: ReminderInterval = if reminderPreferences.alwaysRunning {
            ReminderTimeInterval(
                earliestTime: .earliestToday,
                latestTime: .earliestTomorrow,
                interval: .day
            )
        } else if reminderPreferences.timesOnly {
            ReminderTimeInterval(
                earliestTime: TimeOnly(from: earliestDate),
                latestTime: TimeOnly(from: latestDate),
                interval: repeatInterval
            )
        } else {
            ReminderDateInterval(earliestDate: earliestDate, latestDate: latestDate)
        }
        
        return RandomReminder(
            title: title,
            text: text,
            interval: reminderInterval,
            days: reminderPreferences.specificDays ? days : .allOptions(),
            totalReminders: totalReminders
        )
    }
}
