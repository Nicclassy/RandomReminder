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

    var isInfinite: Bool {
        false
    }

    init(earliest: Date, latest: Date, interval: RepeatInterval = .never) {
        self.earliest = earliest.withoutSeconds()
        self.latest = latest.withoutSeconds()
        self.repeatInterval = interval
    }

    init(earliestTime: TimeOnly, latestTime: TimeOnly, interval: RepeatInterval = .never, date: Date = .now) {
        self.earliest = earliestTime.onDate(date)
        self.latest = latestTime.onDate(date)
        self.repeatInterval = interval
    }

    func nextRepeat() -> Self {
        let repeatedEarliestDate = earliest.addingInterval(repeatInterval)
        let duration = latest.timeIntervalSince(earliest)
        return Self(
            earliest: repeatedEarliestDate,
            latest: repeatedEarliestDate.addingTimeInterval(duration),
            interval: repeatInterval
        )
    }
}

struct ReminderDateInterval: ReminderInterval {
    let earliest: Date
    let latest: Date
    var repeatInterval: RepeatInterval

    var isInfinite: Bool {
        false
    }

    init(earliest: Date, latest: Date, repeatInterval: RepeatInterval = .never) {
        self.earliest = earliest
        self.latest = latest
        self.repeatInterval = repeatInterval
    }

    func nextRepeat() -> Self {
        let repeatedEarliestDate = earliest.addingInterval(repeatInterval)
        let duration = latest.timeIntervalSince(earliest)
        return Self(
            earliest: repeatedEarliestDate,
            latest: repeatedEarliestDate.addingTimeInterval(duration),
            repeatInterval: repeatInterval
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
    var isInfinite: Bool { get }

    func nextRepeat() -> Self
}
