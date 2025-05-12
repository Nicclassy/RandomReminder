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
    let intervalQuantity: Int

    var isInfinite: Bool {
        false
    }

    init(
        earliest: Date,
        latest: Date,
        interval: RepeatInterval = .never,
        intervalQuantity: Int = 1
    ) {
        self.earliest = earliest.withoutSeconds()
        self.latest = latest.withoutSeconds()
        self.repeatInterval = interval
        self.intervalQuantity = intervalQuantity
    }

    init(
        earliestTime: TimeOnly,
        latestTime: TimeOnly,
        interval: RepeatInterval = .never,
        intervalQuantity: Int = 1,
        date: Date = .now
    ) {
        self.earliest = earliestTime.onDate(date)
        self.latest = latestTime.onDate(date)
        self.repeatInterval = interval
        self.intervalQuantity = intervalQuantity
    }

    func nextRepeat() -> Self {
        let repeatedEarliestDate = earliest.addingInterval(repeatInterval, quantity: intervalQuantity)
        let duration = latest.timeIntervalSince(earliest)
        let repeatedLatestDate = repeatedEarliestDate.addingTimeInterval(duration)
        return Self(
            earliest: repeatedEarliestDate,
            latest: repeatedLatestDate,
            interval: repeatInterval,
            intervalQuantity: intervalQuantity
        )
    }
}

struct ReminderDateInterval: ReminderInterval {
    let earliest: Date
    let latest: Date
    let repeatInterval: RepeatInterval
    let intervalQuantity: Int

    var isInfinite: Bool {
        false
    }

    init(
        earliest: Date,
        latest: Date,
        repeatInterval: RepeatInterval = .never,
        intervalQuantity: Int = 1
    ) {
        self.earliest = earliest
        self.latest = latest
        self.repeatInterval = repeatInterval
        self.intervalQuantity = intervalQuantity
    }

    func nextRepeat() -> Self {
        let repeatedEarliestDate = earliest.addingInterval(repeatInterval, quantity: intervalQuantity)
        let duration = latest.timeIntervalSince(earliest)
        let repeatedLatestDate = repeatedEarliestDate.addingTimeInterval(duration)
        return Self(
            earliest: repeatedEarliestDate,
            latest: repeatedLatestDate,
            repeatInterval: repeatInterval,
            intervalQuantity: intervalQuantity
        )
    }
}

struct InfiniteReminderInterval: ReminderInterval {
    var earliest: Date {
        .distantPast
    }

    var latest: Date {
        .distantFuture
    }

    var repeatInterval: RepeatInterval {
        .never
    }

    var intervalQuantity: Int {
        0
    }

    var isInfinite: Bool {
        true
    }

    func nextRepeat() -> Self {
        self
    }
}

protocol ReminderInterval: Codable {
    var earliest: Date { get }
    var latest: Date { get }
    var repeatInterval: RepeatInterval { get }
    var intervalQuantity: Int { get }
    var isInfinite: Bool { get }

    func nextRepeat() -> Self
}
