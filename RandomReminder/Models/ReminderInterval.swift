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
    var isFinite: Bool { get }
}

struct ReminderTimeInterval: ReminderInterval {
    var earliestTime: TimeOnly
    var latestTime: TimeOnly
    var repeatInterval: RepeatInterval
    
    var earliest: Date {
        .distantPast
    }
    
    var latest: Date {
        .distantFuture
    }
    
    var isFinite: Bool {
        false
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
    
    var isFinite: Bool {
        true
    }
}
