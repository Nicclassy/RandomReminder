//
//  ReminderBuilder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation

struct ReminderBuilder {
    var title: String?
    var text: String?
    var totalReminders: Int?
    var earliest: Date?
    var latest: Date?
    var repeatInterval: RepeatInterval?
    var activationEvents: [ReminderActivationEvent] = []
    
    init() {}
    
    mutating func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    mutating func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    mutating func totalReminders(_ totalReminders: Int) -> Self {
        self.totalReminders = totalReminders
        return self
    }
    
    mutating func earliest(_ earliest: Date) -> Self {
        self.earliest = earliest
        return self
    }
    
    mutating func latest(_ latest: Date) -> Self {
        self.latest = latest
        return self
    }
    
    mutating func repeatInterval(_ repeatInterval: RepeatInterval) -> Self {
        self.repeatInterval = repeatInterval
        return self
    }
    
    mutating func addActivationEvent(_ activationEvent: ReminderActivationEvent) -> Self {
        self.activationEvents.append(activationEvent)
        return self
    }
    
    func build() -> RandomReminder {
        guard let title, let text, let totalReminders, let earliest, let latest else {
            fatalError("Not all mandatory fields were initialized in the reminder building process")
        }
        
        let reminderInterval: ReminderInterval = if let repeatInterval {
            ReminderTimeInterval(
                earliestTime: TimeOnly(from: earliest),
                latestTime: TimeOnly(from: latest), interval: repeatInterval
            )
        } else {
            ReminderDateInterval(earliestDate: earliest, latestDate: latest)
        }
        
        return RandomReminder(title: title, text: text, interval: reminderInterval, totalReminders: totalReminders)
    }
    
    func buildQuickReminder() -> RandomReminder {
        guard let totalReminders, let text, let earliest, let latest, let repeatInterval else {
            fatalError("Not all mandatory fields were initialized in the reminder building process")
        }
        
        let reminderInterval = ReminderTimeInterval(
            earliestTime: TimeOnly(from: earliest),
            latestTime: TimeOnly(from: latest), interval: repeatInterval
        )
        let reminderContent = ReminderContent(title: "Quick Reminder", text: text)
        
        return RandomReminder(
            id: ReminderID.quickReminderId,
            content: reminderContent,
            reminderInterval: AnyReminderInterval(reminderInterval),
            counts: ReminderCounts(totalReminders: totalReminders),
            state: .disabled,
            activationEvents: [.notification]
        )
    }
}
