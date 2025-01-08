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
    
    func seconds() -> Float {
        return switch self {
        case .hours(let hours): Float(hours) * 3600
        case .minutes(let minutes): Float(minutes) * 60
        case .seconds(let seconds): Float(seconds)
        case .milliseconds(let milliseconds): Float(milliseconds) / 1000
        }
    }
}
