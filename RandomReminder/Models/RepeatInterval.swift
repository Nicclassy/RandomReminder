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
}
