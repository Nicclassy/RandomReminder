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
    @Published var totalOccurences: Int = 1
    @Published var earliestDate: Date = Date()
    @Published var latestDate: Date = Date().addMinutes(60)
    @Published var days: ReminderDayOptions = []
    @Published var repeatInterval: RepeatInterval = .minute
    @Published var activationEvents: ReminderActivationEvents = .init()
    private var occurences: Int = 0
    
    init() {}
    
    init(from reminder: RandomReminder) {
        self.title = reminder.content.title
        self.text = reminder.content.text
        self.occurences = reminder.counts.occurences
        self.totalOccurences = reminder.counts.totalOccurences
        self.earliestDate = reminder.interval.earliest
        self.latestDate = reminder.interval.latest
        self.days = reminder.days
        self.repeatInterval = reminder.interval.repeatInterval
        self.activationEvents = reminder.activationEvents
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
