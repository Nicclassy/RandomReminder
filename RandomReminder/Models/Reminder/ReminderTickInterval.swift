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
        case .hours(let hours): TimeInterval(hours) * 3600
        case .minutes(let minutes): TimeInterval(minutes) * 60
        case .seconds(let seconds): TimeInterval(seconds)
        case .milliseconds(let milliseconds): TimeInterval(milliseconds) / 1000
        }
    }
}
