//
//  AnyReminderInterval.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct AnyReminderInterval: Codable {
    var value: ReminderInterval?
    
    enum CodingKeys: String, CodingKey {
        case timeInterval
        case dateInterval
    }
    
    init(from decoder: any Decoder) throws {
        // TODO: Implement
        // This is a placeholder value
        self.value = nil
    }
    
    func encode(to encoder: any Encoder) throws {}
}
