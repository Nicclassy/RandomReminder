//
//  ReminderDays.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/2/2025.
//

import Foundation

struct ReminderDayOptions: OptionSet, CaseIterable, Codable {
    let rawValue: Int
    
    static let monday: Self = .init(rawValue: 1 << 0)
    static let tuesday: Self = .init(rawValue: 1 << 1)
    static let wednesday: Self = .init(rawValue: 1 << 2)
    static let thursday: Self = .init(rawValue: 1 << 3)
    static let friday: Self = .init(rawValue: 1 << 4)
    static let saturday: Self = .init(rawValue: 1 << 5)
    static let sunday: Self = .init(rawValue: 1 << 6)
    
    static let allCases: [ReminderDayOptions] = [
        .monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday
    ]
}
