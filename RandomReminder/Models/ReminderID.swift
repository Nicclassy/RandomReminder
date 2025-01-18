//
//  ReminderID.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/1/2025.
//

import Foundation

struct ReminderID: Codable {
    static let quickReminderId: ReminderID = 0
    static let firstAvailableId: ReminderID = 1
    
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    static func nextAvailable() -> Self {
        #error ("TODO: Implement this properly")
        return firstAvailableId
    }
}

extension ReminderID: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    
    init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
}

extension ReminderID: Equatable, Hashable {
    static func == (lhs: ReminderID, rhs: ReminderID) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }
}
