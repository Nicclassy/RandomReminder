//
//  AnyReminderInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//  Credit: https://gist.github.com/sanjeevworkstation/3d1e8bd94d4ed83182fb4c2c836e187f
//

import Foundation

struct AnyReminderInterval: Codable {
    let value: ReminderInterval
    
    init(_ value: ReminderInterval) {
        self.value = value
    }
    
    init(from decoder: any Decoder) throws {
        if let timeInterval = try? decoder.singleValueContainer().decode(ReminderTimeInterval.self) {
            self.init(timeInterval)
        } else if let dateInterval = try? decoder.singleValueContainer().decode(ReminderDateInterval.self) {
            self.init(dateInterval)
        } else {
            throw AnyReminderIntervalError.missingValue
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let timeInterval = self.value as? ReminderTimeInterval {
            try container.encode(timeInterval, forKey: .timeInterval)
        } else if let dateInterval = self.value as? ReminderDateInterval {
            try container.encode(dateInterval, forKey: .dateInterval)
        } else {
            throw AnyReminderIntervalError.unknownType
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case timeInterval
        case dateInterval
    }
    
    enum AnyReminderIntervalError: Error {
        case missingValue
        case unknownType
    }
}
