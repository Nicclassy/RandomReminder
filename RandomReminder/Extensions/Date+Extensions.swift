//
//  Date+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation

extension Date {
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var isDistant: Bool {
        self == .distantPast || self == .distantFuture
    }
    
    func addMinutes(_ minutes: Int) -> Self {
        // This method and the method below are saturating additions.
        // This is done by checking for a distant date.
        self.isDistant ? self : Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func subtractMinutes(_ minutes: Int) -> Self {
        self.isDistant ? self : Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }
    
    static func startOfDay(date: Date = Date()) -> Self {
        Calendar.current.startOfDay(for: date)
    }
    
    static func endOfDay(date: Date = Date()) -> Self {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay())!.subtractMinutes(1)
    }
    
    func sameTimeToday() -> Self? {
        let calendar = Calendar.current
        let today = Date()
        let todaysTime = calendar.dateComponents([.hour, .minute], from: self)
        var result = calendar.dateComponents([.year, .month, .day], from: today)
        result.hour = todaysTime.hour
        result.minute = todaysTime.minute
        return calendar.date(from: result)
    }
    
    func formatYearMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yy"
        return formatter.string(from: self)
    }
}
