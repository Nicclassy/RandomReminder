//
//  RepeatInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

enum RepeatIntervalType: Codable, Equatable, Hashable, CaseIterable {
    case every
    case after
}

enum RepeatInterval: Codable, Equatable, Hashable, CaseIterable {
    case never
    case minute
    case hour
    case day
    case week
    case month

    func timeInterval() -> TimeInterval {
        switch self {
        case .never: 0
        case .minute: 60
        case .hour: 3600
        case .day: 86400
        case .week: 604_800
        case .month: 2_629_746
        }
    }
}
