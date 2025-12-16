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

    func name(for quantity: Int) -> String {
        let plural = quantity != 1
        return switch self {
        case .second: TimeInfoProvider.seconds(plural: plural)
        case .minute: TimeInfoProvider.minutes(plural: plural)
        case .hour: TimeInfoProvider.hours(plural: plural)
        case .day: TimeInfoProvider.days(plural: plural)
        case .week: TimeInfoProvider.weeks(plural: plural)
        case .month: TimeInfoProvider.months(plural: plural)
        default: fatalError("The interval 'never' does not have a name")
        }
    }
}

extension RepeatInterval {
    static var gapIntervals: [Self] {
        [.second, .minute, .hour, .day]
    }
}

extension RepeatInterval: EnumRawRepresentable {}
