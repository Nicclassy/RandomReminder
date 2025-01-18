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
}

struct ReminderTimeInterval: ReminderInterval {
    var earliestTime: TimeOnly
    var latestTime: TimeOnly
    var interval: RepeatInterval
    
    var earliest: Date {
        self.earliestTime.dateToday()
    }
    
    var latest: Date {
        self.latestTime.dateToday()
    }
    
    var repeatInterval: RepeatInterval {
        self.interval
    }
}

struct ReminderDateInterval: ReminderInterval {
    var earliestDate: Date
    var latestDate: Date
    
    var earliest: Date {
        self.earliestDate
    }
    
    var latest: Date {
        self.latestDate
    }
    
    var repeatInterval: RepeatInterval {
        .noRepeat
    }
}
