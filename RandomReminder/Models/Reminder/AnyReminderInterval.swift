//
//  AnyReminderInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//  Credits: https://gist.github.com/sanjeevworkstation/3d1e8bd94d4ed83182fb4c2c836e187f

import Foundation

final class AnyReminderInterval: Codable {
    enum CodingKeys: String, CodingKey {
        case timeInterval
        case dateInterval
    }

    enum AnyReminderIntervalError: Swift.Error {
        case missingValue
        case unknownType
    }

    let value: ReminderInterval

    init(_ value: ReminderInterval) {
        self.value = value
    }

    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let timeInterval = try? container.decode(ReminderTimeInterval.self, forKey: .timeInterval) {
            self.init(timeInterval)
        } else if let dateInterval = try? container.decode(ReminderDateInterval.self, forKey: .dateInterval) {
            self.init(dateInterval)
        } else {
            throw AnyReminderIntervalError.missingValue
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let timeInterval = value as? ReminderTimeInterval {
            try container.encode(timeInterval, forKey: .timeInterval)
        } else if let dateInterval = value as? ReminderDateInterval {
            try container.encode(dateInterval, forKey: .dateInterval)
        } else {
            throw AnyReminderIntervalError.unknownType
        }
    }
}

extension AnyReminderInterval: CustomStringConvertible {
    var description: String {
        let mirror = Mirror(reflecting: value)
        let properties = mirror.children
            .map { "\($0.label ?? "?") = \($0.value)" }
            .joined(separator: ", ")
        return "\(type(of: self)) { \(properties) }"
    }
}
