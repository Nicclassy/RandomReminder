//
//  ReminderTickInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 4/1/2025.
//

import Foundation

enum ReminderTickInterval {
    case hours(Int)
    case minutes(Int)
    case seconds(Int)
    case milliseconds(Int)

    func seconds() -> TimeInterval {
        switch self {
        case let .hours(hours): TimeInterval(hours) * 3600
        case let .minutes(minutes): TimeInterval(minutes) * 60
        case let .seconds(seconds): TimeInterval(seconds)
        case let .milliseconds(milliseconds): TimeInterval(milliseconds) / 1000
        }
    }
}
