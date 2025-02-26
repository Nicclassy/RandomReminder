//
//  ReminderID.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/1/2025.
//

import Foundation

struct ReminderID: Codable {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
}

extension ReminderID {
    static let quickReminderId: ReminderID = 0
    static let firstAvailableId: ReminderID = 1
    
    func filename() -> String {
        URL(string: String(describing: value))!
            .appendingPathExtension(StoredReminders.fileExtension)
            .path()
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

extension ReminderID: Comparable {
    static func < (lhs: ReminderID, rhs: ReminderID) -> Bool {
        lhs.value < rhs.value
    }
}

extension ReminderID: Strideable {
    func distance(to other: ReminderID) -> Int {
        other.value - self.value
    }
   
   func advanced(by n: Int) -> ReminderID {
       ReminderID(self.value + n)
   }
}
