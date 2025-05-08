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

    static func startOfDay(date: Date = Date()) -> Self {
        Calendar.current.startOfDay(for: date)
    }

    static func endOfDay(date: Date = Date()) -> Self {
        // As a consequence of this design, start/end times must be in the domain [start, end].
        // While it is possible to do [start, end) (e.g. start is 12am and end is 12am),
        // this is a more confusing alternative
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay(date: date).subtractMinutes(1))!
    }

    func addMinutes(_ minutes: Int) -> Self {
        // This method and the method below are saturating operations.
        // This operation is saturating because of the distant date check
        isDistant ? self : Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    func subtractMinutes(_ minutes: Int) -> Self {
        isDistant ? self : Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }

    func addSeconds(_ seconds: Int) -> Self {
        isDistant ? self : Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }

    func addingInterval(_ interval: RepeatInterval) -> Self {
        let (component, value): (Calendar.Component, Int) = switch interval {
        case .minute: (.minute, 1)
        case .hour: (.hour, 1)
        case .day: (.day, 1)
        case .week: (.day, 7)
        case .month: (.month, 1)
        default: fatalError("Repeat interval 'never' does not have a corresponding calendar component")
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
