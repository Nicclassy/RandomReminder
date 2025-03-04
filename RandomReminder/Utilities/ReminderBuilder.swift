//
//  ReminderBuilder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation

final class ReminderBuilder: ObservableObject {
    @Published var title: String
    @Published var text: String
    @Published var totalOccurences: Int
    @Published var earliestDate: Date
    @Published var latestDate: Date
    @Published var days: ReminderDayOptions
    @Published var repeatInterval: RepeatInterval
    @Published var activationEvents: ReminderActivationEvents
    private var occurences: Int
    
    init() {
        title = String()
        text = String()
        totalOccurences = 1
        earliestDate = Date()
        latestDate = Date().addMinutes(60)
        days = []
        repeatInterval = .minute
        activationEvents = ReminderActivationEvents()
        occurences = 0
    }
    
    init(from reminder: RandomReminder) {
        title = reminder.content.title
        text = reminder.content.text
        occurences = reminder.counts.occurences
        totalOccurences = reminder.counts.totalOccurences
        earliestDate = reminder.interval.earliest
        latestDate = reminder.interval.latest
        days = reminder.days
        repeatInterval = reminder.interval.repeatInterval
        activationEvents = reminder.activationEvents
    }
    
    func build(preferences reminderPreferences: ReminderPreferences) -> RandomReminder {
        let reminderInterval: ReminderInterval = if reminderPreferences.alwaysRunning {
            ReminderTimeInterval.infinite
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
            totalOccurences: totalOccurences
        )
    }
}
