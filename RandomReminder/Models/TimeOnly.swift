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
    
    static let earliestToday = TimeOnly(hour: 1)
    static let earliestTomorrow = TimeOnly(hour: 25)
    
    init(hour: Int, minute: Int) {
        assert(hour >= 0 && hour < 24)
        assert(minute >= 0 && minute < 60)
        self.hour = hour
        self.minute = minute
    }
    
    init(from date: Date) {
        self.init(hour: date.hour, minute: date.minute)
    }
    
    init(timeIntervalSince1970: TimeInterval) {
        self.init(from: Date(timeIntervalSince1970: timeIntervalSince1970))
    }
    
    private init(hour: Int) {
        self.hour = hour
        self.minute = 0
    }
    
    func onDate(date: Date) -> Date {
        let calendar = Calendar.current
        let (additionalDays, hours) = hour.quotientAndRemainder(dividingBy: 24)
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = components.day! + additionalDays
        components.hour = hours
        components.minute = minute
        return calendar.date(from: components)!
    }
    
    func dateToday() -> Date {
        onDate(date: Date())
    }
}

extension TimeOnly: Equatable, Hashable {
    static func == (lhs: TimeOnly, rhs: TimeOnly) -> Bool {
        lhs.hour == rhs.hour && lhs.minute == rhs.minute
    }
}
