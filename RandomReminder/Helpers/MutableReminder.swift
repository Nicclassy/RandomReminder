//
//  MutableReminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation

final class MutableReminder: ObservableObject {
    private static let `default` = MutableReminder(
        id: .unassigned,
        title: String(),
        text: String(),
        totalOccurences: 1,
        earliestDate: Date(),
        latestDate: Date().addMinutes(60),
        days: [],
        repeatInterval: .minute,
        activationEvents: ReminderActivationEvents(),
        occurences: 0
    )

    var id: ReminderID
    @Published var title: String
    @Published var text: String
    @Published var totalOccurences: Int
    @Published var earliestDate: Date
    @Published var latestDate: Date
    @Published var days: ReminderDayOptions
    @Published var repeatInterval: RepeatInterval
    @Published var activationEvents: ReminderActivationEvents
    var occurences: Int

    init(
        id: ReminderID,
        title: String,
        text: String,
        totalOccurences: Int,
        earliestDate: Date,
        latestDate: Date,
        days: ReminderDayOptions,
        repeatInterval: RepeatInterval,
        activationEvents: ReminderActivationEvents,
        occurences: Int
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.totalOccurences = totalOccurences
        self.earliestDate = earliestDate
        self.latestDate = latestDate
        self.days = days
        self.repeatInterval = repeatInterval
        self.activationEvents = activationEvents
        self.occurences = occurences
    }

    init(reminder: MutableReminder) {
        self.id = reminder.id
        self.title = reminder.title
        self.text = reminder.text
        self.totalOccurences = reminder.totalOccurences
        self.earliestDate = reminder.earliestDate
        self.latestDate = reminder.latestDate
        self.days = reminder.days
        self.repeatInterval = reminder.repeatInterval
        self.activationEvents = reminder.activationEvents
        self.occurences = reminder.occurences
    }

    convenience init() {
        self.init(reminder: .default)
    }

    func reset() {
        copyFrom(reminder: .default)
    }

    func copyFrom(reminder: MutableReminder) {
        id = reminder.id
        title = reminder.title
        text = reminder.text
        totalOccurences = reminder.totalOccurences
        earliestDate = reminder.earliestDate
        latestDate = reminder.latestDate
        days = reminder.days
        repeatInterval = reminder.repeatInterval
        activationEvents = reminder.activationEvents
        occurences = reminder.occurences
    }

    func copyFrom(reminder: RandomReminder) {
        id = reminder.id
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
            totalOccurences: totalOccurences,
            activationEvents: reminderPreferences.useAudioFile ? activationEvents : nil
        )
    }
}
