//
//  ReminderInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct ReminderTimeInterval: ReminderInterval {
    let earliest: Date
    let latest: Date
    let repeatInterval: RepeatInterval
    let repeatIntervalType: RepeatIntervalType
    let intervalQuantity: Int

    var isInfinite: Bool {
        false
    }

    init(
        earliest: Date,
        latest: Date,
        repeatInterval: RepeatInterval = .never,
        repeatIntervalType: RepeatIntervalType = .every,
        intervalQuantity: Int = 1
    ) {
        self.earliest = earliest.withoutSeconds()
        self.latest = latest.withoutSeconds()
        self.repeatInterval = repeatInterval
        self.repeatIntervalType = repeatIntervalType
        self.intervalQuantity = intervalQuantity
    }

    init(
        earliestTime: TimeOnly,
        latestTime: TimeOnly,
        repeatInterval: RepeatInterval = .never,
        repeatIntervalType: RepeatIntervalType = .every,
        intervalQuantity: Int = 1,
        date: Date = .now
    ) {
        self.earliest = earliestTime.onDate(date)
        self.latest = latestTime.onDate(date)
        self.repeatInterval = repeatInterval
        self.repeatIntervalType = repeatIntervalType
        self.intervalQuantity = intervalQuantity
    }

    func nextRepeat() -> Self {
        let startDate = repeatIntervalType == .every ? earliest : Date()
        let repeatedEarliestDate = startDate.addingInterval(repeatInterval, quantity: intervalQuantity)
        let duration = latest.timeIntervalSince(earliest)
        let repeatedLatestDate = repeatedEarliestDate.addingTimeInterval(duration)
        return Self(
            earliest: repeatedEarliestDate,
            latest: repeatedLatestDate,
            repeatInterval: repeatInterval,
            repeatIntervalType: repeatIntervalType,
            intervalQuantity: intervalQuantity
        )
    }
}

struct ReminderDateInterval: ReminderInterval {
    let earliest: Date
    let latest: Date
    let repeatInterval: RepeatInterval
    let repeatIntervalType: RepeatIntervalType
    let intervalQuantity: Int

    var isInfinite: Bool {
        false
    }

    init(
        earliest: Date,
        latest: Date,
        repeatInterval: RepeatInterval = .never,
        repeatIntervalType: RepeatIntervalType = .every,
        intervalQuantity: Int = 1
    ) {
        self.earliest = earliest
        self.latest = latest
        self.repeatInterval = repeatInterval
        self.repeatIntervalType = repeatIntervalType
        self.intervalQuantity = intervalQuantity
    }

    func nextRepeat() -> Self {
        let startDate = repeatIntervalType == .every ? earliest : Date()
        let repeatedEarliestDate = startDate.addingInterval(repeatInterval, quantity: intervalQuantity)
        let duration = latest.timeIntervalSince(earliest)
        let repeatedLatestDate = repeatedEarliestDate.addingTimeInterval(duration)
        return Self(
            earliest: repeatedEarliestDate,
            latest: repeatedLatestDate,
            repeatInterval: repeatInterval,
            repeatIntervalType: repeatIntervalType,
            intervalQuantity: intervalQuantity
        )
    }
}

struct InfiniteReminderInterval: ReminderInterval {
    let earliest: Date
    let latest: Date

    var repeatInterval: RepeatInterval {
        .day
    }

    var repeatIntervalType: RepeatIntervalType {
        .every
    }

    var intervalQuantity: Int {
        1
    }

    var isInfinite: Bool {
        true
    }

    init() {
        self.earliest = .startOfDay()
        self.latest = .endOfDay()
    }

    func nextRepeat() -> Self {
        Self()
    }
}

protocol ReminderInterval: Codable {
    var earliest: Date { get }
    var latest: Date { get }
    var repeatInterval: RepeatInterval { get }
    var repeatIntervalType: RepeatIntervalType { get }
    var intervalQuantity: Int { get }
    var isInfinite: Bool { get }

    func nextRepeat() -> Self
}
