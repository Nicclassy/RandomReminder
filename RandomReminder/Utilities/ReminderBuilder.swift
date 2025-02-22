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
    @Published var earliest: Date = Date()
    @Published var latest: Date = Date().addMinutes(60)
    @Published var days: ReminderDayOptions = []
    @Published var repeatInterval: RepeatInterval = .none
    @Published var activationEvents: ReminderActivationEvents = .init()
    
    init() {}
    
    func build(specificDays: Bool) -> RandomReminder {
        let reminderInterval: ReminderInterval = if repeatInterval != .none {
            ReminderTimeInterval(
                earliestTime: TimeOnly(from: earliest),
                latestTime: TimeOnly(from: latest), interval: repeatInterval
            )
        } else {
            ReminderDateInterval(earliestDate: earliest, latestDate: latest)
        }
        
        return RandomReminder(
            title: title,
            text: text,
            interval: reminderInterval,
            days: specificDays ? days : [],
            totalReminders: totalReminders
        )
    }
}
