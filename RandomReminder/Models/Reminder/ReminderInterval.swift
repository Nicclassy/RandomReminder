//
//  ReminderInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct ReminderTimeInterval: ReminderInterval {
    static var infinite: ReminderInterval {
        Self(
            earliestTime: .earliestToday,
            latestTime: .earliestTomorrow,
            interval: .day
        )
    }

    var earliestTime: TimeOnly
    var latestTime: TimeOnly
    var interval: RepeatInterval

    var earliest: Date {
        earliestTime.dateToday()
    }

    var latest: Date {
        latestTime.dateToday()
    }

    var repeatInterval: RepeatInterval {
        interval
    }

    var isInfinite: Bool {
        earliestTime == .earliestToday && latestTime == .earliestTomorrow
    }
}

struct ReminderDateInterval: ReminderInterval {
    var earliestDate: Date
    var latestDate: Date

    var earliest: Date {
        earliestDate
    }

    var latest: Date {
        latestDate
    }

    var repeatInterval: RepeatInterval {
        .never
    }

    var isInfinite: Bool {
        false
    }
}

protocol ReminderInterval: Codable {
    var earliest: Date { get }
    var latest: Date { get }
    var repeatInterval: RepeatInterval { get }
    var isInfinite: Bool { get }
}
