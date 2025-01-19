//
//  TimeOnly.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation

struct TimeOnly: Codable {
    var hour: Int
    var minute: Int
    
    init(hour: Int, minute: Int) {
        // Not needed but might as well have these sanity checks
        assert(hour >= 0 && hour < 24)
        assert(minute >= 0 && minute < 60)
        self.hour = hour
        self.minute = minute
    }
    
    init(from date: Date) {
        self.init(hour: date.hour, minute: date.minute)
    }
    
    func onDate(date: Date) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .year], from: date)
        components.hour = self.hour
        components.minute = self.minute
        return calendar.date(from: components)!
    }
    
    func dateToday() -> Date {
        self.onDate(date: Date())
    }
}
