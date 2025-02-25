//
//  ReminderInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

protocol ReminderInterval: Codable {
    var earliest: Date { get }
    var latest: Date { get }
    var repeatInterval: RepeatInterval { get }
    var isInfinite: Bool { get }
}

struct ReminderTimeInterval: ReminderInterval {
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
    
    static var infinite: ReminderInterval {
        ReminderTimeInterval(
            earliestTime: .earliestToday,
            latestTime: .earliestTomorrow,
            interval: .day
        )
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
        .none
    }
    
    var isInfinite: Bool {
        false
    }
}
