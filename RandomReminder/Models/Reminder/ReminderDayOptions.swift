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

    /// Weekday names will be localised
    var name: String {
        switch self {
        case .monday: "Monday"
        case .tuesday: "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday: "Thursday"
        case .friday: "Friday"
        case .saturday: "Saturday"
        case .sunday: "Sunday"
        default: ""
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
}
