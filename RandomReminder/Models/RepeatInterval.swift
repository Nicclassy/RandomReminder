//
//  RepeatInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

typealias TimeUnit = RepeatInterval

enum RepeatIntervalType: Codable, Equatable, Hashable, CaseIterable {
    case every
    case after
}

enum RepeatInterval: Codable, Equatable, Hashable, CaseIterable {
    case never
    case second
    case minute
    case hour
    case day
    case week
    case month

    var timeInterval: TimeInterval {
        switch self {
        case .never: 0
        case .second: 1
        case .minute: 60
        case .hour: 3600
        case .day: 86400
        case .week: 604_800
        case .month: 2_629_746
        }
    }
    
    var singularName: String {
        switch self {
        case .second: L10n.second
        case .minute: L10n.minute
        case .hour: L10n.hour
        case .day: L10n.day
        case .week: L10n.week
        case .month: L10n.month
        case .never: fatalError("singularName shouldn't be called on .never")
        }
    }
    
    var pluralName: String {
        switch self {
        case .second: L10n.seconds
        case .minute: L10n.minutes
        case .hour: L10n.hours
        case .day: L10n.days
        case .week: L10n.weeks
        case .month: L10n.months
        case .never: fatalError("pluralName shouldn't be called on .never")
        }
    }
    
    func name(for quantity: Int) -> String {
        quantity == 1 ? singularName : pluralName
    }
}

extension RepeatInterval {
    static var gapIntervals: [RepeatInterval] {
        [.second, .minute, .hour, .day]
    }
}

extension RepeatInterval: EnumRawRepresentable {}
