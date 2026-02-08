//
//  MutableReminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation

@Observable
final class MutableReminder {
    private static let defaultIntervalTimeUnit: TimeUnit = .minute
    private static let defaultIntervalAmount = 60
    private static let offsetTimeUnit: TimeUnit = .minute
    private static let startOffsetFromNow = 5

    private static let `default` = MutableReminder(
        id: .unassigned,
        title: String(),
        description: .emptyText,
        totalOccurrences: 1,
        earliestDate: defaultEarliestDate,
        latestDate: defaultLatestDate,
        days: [],
        repeatInterval: .minute,
        repeatIntervalType: .every,
        intervalQuantity: 1,
        activationEvents: ReminderActivationEvents(),
        occurrences: 0
    )

    private static var defaultEarliestDate: Date {
        Date().addingInterval(offsetTimeUnit, quantity: startOffsetFromNow)
    }

    private static var defaultLatestDate: Date {
        defaultEarliestDate.addingInterval(defaultIntervalTimeUnit, quantity: defaultIntervalAmount)
    }

    var id: ReminderID
    var title: String
    var description: ReminderDescription
    var totalOccurrences: Int
    var earliestDate: Date
    var latestDate: Date
    var days: ReminderDayOptions
    var repeatInterval: RepeatInterval
    var repeatIntervalType: RepeatIntervalType
    var intervalQuantity: Int
    var activationEvents: ReminderActivationEvents
    var occurrences: Int

    init(
        id: ReminderID,
        title: String,
        description: ReminderDescription,
        totalOccurrences: Int,
        earliestDate: Date,
        latestDate: Date,
        days: ReminderDayOptions,
        repeatInterval: RepeatInterval,
        repeatIntervalType: RepeatIntervalType,
        intervalQuantity: Int,
        activationEvents: ReminderActivationEvents,
        occurrences: Int
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.totalOccurrences = totalOccurrences
        self.earliestDate = earliestDate
        self.latestDate = latestDate
        self.days = days
        self.repeatInterval = repeatInterval
        self.repeatIntervalType = repeatIntervalType
        self.intervalQuantity = intervalQuantity
        self.activationEvents = activationEvents
        self.occurrences = occurrences
    }

    init(reminder: MutableReminder) {
        self.id = reminder.id
        self.title = reminder.title
        self.description = reminder.description
        self.totalOccurrences = reminder.totalOccurrences
        self.earliestDate = reminder.earliestDate
        self.latestDate = reminder.latestDate
        self.days = reminder.days
        self.repeatInterval = reminder.repeatInterval
        self.repeatIntervalType = reminder.repeatIntervalType
        self.intervalQuantity = reminder.intervalQuantity
        self.activationEvents = reminder.activationEvents
        self.occurrences = reminder.occurrences
    }

    convenience init(from reminder: RandomReminder) {
        self.init(
            id: reminder.id,
            title: reminder.content.title,
            description: reminder.content.description,
            totalOccurrences: reminder.counts.totalOccurrences,
            earliestDate: reminder.interval.earliest,
            latestDate: reminder.interval.latest,
            days: reminder.days,
            repeatInterval: reminder.interval.repeatInterval == .never
                ? Self.default.repeatInterval
                : reminder.interval.repeatInterval,
            repeatIntervalType: reminder.interval.repeatIntervalType,
            intervalQuantity: reminder.interval.intervalQuantity,
            activationEvents: reminder.activationEvents,
            occurrences: reminder.counts.occurrences
        )
    }

    convenience init() {
        self.init(reminder: .default)
    }

    func reset() {
        copyFrom(reminder: .default)
    }

    func resetDates() {
        earliestDate = Self.defaultEarliestDate
        latestDate = Self.defaultLatestDate
    }

    func copyFrom(reminder: MutableReminder) {
        id = reminder.id
        title = reminder.title
        description = reminder.description
        totalOccurrences = reminder.totalOccurrences
        earliestDate = reminder.earliestDate
        latestDate = reminder.latestDate
        days = reminder.days
        repeatInterval = reminder.repeatInterval
        repeatIntervalType = reminder.repeatIntervalType
        activationEvents = reminder.activationEvents
        intervalQuantity = reminder.intervalQuantity
        occurrences = reminder.occurrences
    }

    func copyFrom(reminder: RandomReminder) {
        id = reminder.id
        title = reminder.content.title
        description = reminder.content.description
        occurrences = reminder.counts.occurrences
        totalOccurrences = reminder.counts.totalOccurrences
        earliestDate = reminder.interval.earliest
        latestDate = reminder.interval.latest
        days = reminder.days
        repeatInterval = reminder.interval.repeatInterval == .never
            ? Self.default.repeatInterval
            : reminder.interval.repeatInterval
        repeatIntervalType = reminder.interval.repeatIntervalType
        intervalQuantity = reminder.interval.intervalQuantity
        activationEvents = reminder.activationEvents
    }

    func build(preferences reminderPreferences: ReminderPreferences) -> RandomReminder {
        let repeatInterval = reminderPreferences.repeatingEnabled ? repeatInterval : .never
        let days: ReminderDayOptions = if reminderPreferences.nonRandom {
            reminderPreferences.timesOnly && reminderPreferences.specificDays ? days : []
        } else if reminderPreferences.specificDays {
            days
        } else {
            .allOptions()
        }

        let reminderInterval: ReminderInterval = if reminderPreferences.alwaysRunning {
            InfiniteReminderInterval()
        } else if reminderPreferences.nonRandom {
            ReminderNonInterval(
                date: earliestDate.withoutSeconds(),
                days: days
            )
        } else if reminderPreferences.timesOnly {
            ReminderTimeInterval(
                earliestTime: TimeOnly(from: earliestDate),
                latestTime: TimeOnly(from: latestDate),
                repeatInterval: repeatInterval,
                repeatIntervalType: repeatIntervalType,
                intervalQuantity: intervalQuantity
            )
        } else {
            ReminderDateInterval(
                earliest: earliestDate.withoutSeconds(),
                latest: latestDate.withoutSeconds(),
                repeatInterval: repeatInterval,
                repeatIntervalType: repeatIntervalType,
                intervalQuantity: intervalQuantity
            )
        }

        if !reminderPreferences.useAudioFile {
            activationEvents.audio = nil
        }
        activationEvents.showWhenActive = reminderPreferences.showWhenActive
        activationEvents.command.isEnabled = reminderPreferences.activationCommandEnabled

        return RandomReminder(
            title: title,
            description: description,
            interval: reminderInterval,
            days: days,
            totalOccurrences: reminderPreferences.nonRandom ? 1 : totalOccurrences,
            activationEvents: activationEvents
        )
    }
}

extension MutableReminder {
    var reflectedDescription: String {
        let mirror = Mirror(self, children: [
            "id": id,
            "title": title,
            "description": description,
            "totalOccurrences": totalOccurrences,
            "earliestDate": earliestDate,
            "latestDate": latestDate,
            "days": days,
            "repeatInterval": repeatInterval,
            "repeatIntervalType": repeatIntervalType,
            "intervalQuantity": intervalQuantity,
            "activationEvents": activationEvents,
            "occurrences": occurrences
        ])
        let properties = mirror.children
            .map { "\($0.label ?? "?") = \($0.value)" }
            .joined(separator: ", ")
        return "\(type(of: self)) { \(properties) }"
    }
}
