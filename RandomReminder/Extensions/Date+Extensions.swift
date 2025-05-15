//
//  Date+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation

extension Date {
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }

    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    static func startOfDay(date: Date = Date()) -> Self {
        Calendar.current.startOfDay(for: date)
    }

    static func endOfDay(date: Date = Date()) -> Self {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay(date: date))!
    }

    func addMinutes(_ minutes: Int) -> Self {
        // This method and the method below are saturating operations.
        // This operation is saturating because of the distant date check
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    func subtractMinutes(_ minutes: Int) -> Self {
        Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }

    func addSeconds(_ seconds: Int) -> Self {
        Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }

    func addingInterval(_ interval: RepeatInterval, quantity: Int) -> Self {
        let (component, value): (Calendar.Component, Int) = switch interval {
        case .minute: (.minute, quantity)
        case .hour: (.hour, quantity)
        case .day: (.day, quantity)
        case .week: (.day, quantity * 7)
        case .month: (.month, quantity)
        default: fatalError("Repeat interval \(interval) does not have a corresponding calendar component")
        }
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    func withoutSeconds() -> Self {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }

    func formatYearMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yy"
        return formatter.string(from: self)
    }
}
