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
        totalOccurences: 1,
        earliestDate: defaultEarliestDate,
        latestDate: defaultLatestDate,
        days: [],
        repeatInterval: .minute,
        repeatIntervalType: .every,
        intervalQuantity: 1,
        activationEvents: ReminderActivationEvents(),
        occurences: 0
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
    var totalOccurences: Int
    var earliestDate: Date
    var latestDate: Date
    var days: ReminderDayOptions
    var repeatInterval: RepeatInterval
    var repeatIntervalType: RepeatIntervalType
    var intervalQuantity: Int
    var activationEvents: ReminderActivationEvents
    var occurences: Int

    init(
        id: ReminderID,
        title: String,
        description: ReminderDescription,
        totalOccurences: Int,
        earliestDate: Date,
        latestDate: Date,
        days: ReminderDayOptions,
        repeatInterval: RepeatInterval,
        repeatIntervalType: RepeatIntervalType,
        intervalQuantity: Int,
        activationEvents: ReminderActivationEvents,
        occurences: Int
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.totalOccurences = totalOccurences
        self.earliestDate = earliestDate
        self.latestDate = latestDate
        self.days = days
        self.repeatInterval = repeatInterval
        self.repeatIntervalType = repeatIntervalType
        self.intervalQuantity = intervalQuantity
        self.activationEvents = activationEvents
        self.occurences = occurences
    }

    init(reminder: MutableReminder) {
        self.id = reminder.id
        self.title = reminder.title
        self.description = reminder.description
        self.totalOccurences = reminder.totalOccurences
        self.earliestDate = reminder.earliestDate
        self.latestDate = reminder.latestDate
        self.days = reminder.days
        self.repeatInterval = reminder.repeatInterval
        self.repeatIntervalType = reminder.repeatIntervalType
        self.intervalQuantity = reminder.intervalQuantity
        self.activationEvents = reminder.activationEvents
        self.occurences = reminder.occurences
    }

    convenience init(from reminder: RandomReminder) {
        self.init(
            id: reminder.id,
            title: reminder.content.title,
            description: reminder.content.description,
            totalOccurences: reminder.counts.totalOccurences,
            earliestDate: reminder.interval.earliest,
            latestDate: reminder.interval.latest,
            days: reminder.days,
            repeatInterval: reminder.interval.repeatInterval == .never
                ? Self.default.repeatInterval
                : reminder.interval.repeatInterval,
            repeatIntervalType: reminder.interval.repeatIntervalType,
            intervalQuantity: reminder.interval.intervalQuantity,
            activationEvents: reminder.activationEvents,
            occurences: reminder.counts.occurences
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
        totalOccurences = reminder.totalOccurences
        earliestDate = reminder.earliestDate
        latestDate = reminder.latestDate
        days = reminder.days
        repeatInterval = reminder.repeatInterval
        repeatIntervalType = reminder.repeatIntervalType
        activationEvents = reminder.activationEvents
        intervalQuantity = reminder.intervalQuantity
        occurences = reminder.occurences
    }

    func copyFrom(reminder: RandomReminder) {
        id = reminder.id
        title = reminder.content.title
        description = reminder.content.description
        occurences = reminder.counts.occurences
        totalOccurences = reminder.counts.totalOccurences
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
                earliest: earliestDate,
                latest: latestDate,
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
            totalOccurences: reminderPreferences.nonRandom ? 1 : totalOccurences,
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
            "totalOccurences": totalOccurences,
            "earliestDate": earliestDate,
            "latestDate": latestDate,
            "days": days,
            "repeatInterval": repeatInterval,
            "repeatIntervalType": repeatIntervalType,
            "intervalQuantity": intervalQuantity,
            "activationEvents": activationEvents,
            "occurences": occurences
        ])
        let properties = mirror.children
            .map { "\($0.label ?? "?") = \($0.value)" }
            .joined(separator: ", ")
        return "\(type(of: self)) { \(properties) }"
    }
}
