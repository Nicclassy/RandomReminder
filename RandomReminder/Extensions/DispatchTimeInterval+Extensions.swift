//
//  DispatchTimeInterval+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 4/1/2025.
//

import Foundation

extension DispatchTimeInterval {
    func seconds() -> Float {
        return switch self {
        case .seconds(let seconds): Float(seconds)
        case .milliseconds(let milliseconds): Float(milliseconds) / 1000.0
        case .microseconds(let microseconds): Float(microseconds) / 1_000_000.0
        case .nanoseconds(let nanoseconds): Float(nanoseconds) / 1_000_000_000.0
        default: 0.0
        }
    }
}
