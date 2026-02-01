//
//  ReminderDayOptions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/2/2025.
//

import Foundation

struct ReminderDayOptions: OptionSet, CaseIterable, Codable {
    static let monday: Self = .init(rawValue: 1 << 0)
    static let tuesday: Self = .init(rawValue: 1 << 1)
    static let wednesday: Self = .init(rawValue: 1 << 2)
    static let thursday: Self = .init(rawValue: 1 << 3)
    static let friday: Self = .init(rawValue: 1 << 4)
    static let saturday: Self = .init(rawValue: 1 << 5)
    static let sunday: Self = .init(rawValue: 1 << 6)

    static let allCases: [Self] = [
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday
    ]

    static var today: Self {
        let date = Date()
        let weekdayNumber = Calendar.current.component(.weekday, from: date)
        return Self(weekdayNumber: weekdayNumber)
    }

    var rawValue: Int

    var name: String {
        switch self {
        case .monday: L10n.monday
        case .tuesday: L10n.tuesday
        case .wednesday: L10n.wednesday
        case .thursday: L10n.thursday
        case .friday: L10n.friday
        case .saturday: L10n.saturday
        case .sunday: L10n.sunday
        default: fatalError("Unknown name for instance with raw value \(rawValue)")
        }
    }

    var weekdayNumber: Int {
        switch self {
        case .sunday: 1
        case .monday: 2
        case .tuesday: 3
        case .wednesday: 4
        case .thursday: 5
        case .friday: 6
        case .saturday: 7
        default: fatalError("No weekday number for \(self)")
        }
    }

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(weekdayNumber: Int) {
        self = switch weekdayNumber {
        case 1: .sunday
        case 2: .monday
        case 3: .tuesday
        case 4: .wednesday
        case 5: .thursday
        case 6: .friday
        case 7: .saturday
        default: fatalError("Unknown weekday number \(weekdayNumber)")
        }
    }

    func nextOccurringDay() -> Self {
        let today = ReminderManager.shared.todaysDay
        var weekdayNumber = today != .saturday ? today.weekdayNumber + 1 : 1
        for _ in 1...7 {
            let day = Self(weekdayNumber: weekdayNumber)
            if contains(day) {
                return day
            }
            weekdayNumber = weekdayNumber != 7 ? weekdayNumber + 1 : 1
        }

        fatalError("Could not find next occuring day")
    }

    func nextOccurrence(from date: Date) -> Date {
        Calendar.current.nextDate(
            after: date,
            matching: DateComponents(weekday: weekdayNumber),
            matchingPolicy: .nextTime,
            direction: .forward
        )!
    }
}
