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
    static let unassigned: ReminderID = -1
    static let quickReminder: ReminderID = 0
    static let first: ReminderID = 1
}

extension ReminderID: Equatable, Hashable {
    static func == (lhs: ReminderID, rhs: ReminderID) -> Bool {
        lhs.value == rhs.value
    }

    static func == (lhs: ReminderID, rhs: Int) -> Bool {
        lhs.value == rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension ReminderID: Comparable {
    static func < (lhs: ReminderID, rhs: ReminderID) -> Bool {
        lhs.value < rhs.value
    }
}

extension ReminderID: Strideable {
    func distance(to other: ReminderID) -> Int {
        other.value - value
    }

    func advanced(by n: Int) -> Self {
        Self(value + n)
    }
}

extension ReminderID: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int

    init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
}

extension ReminderID: CustomStringConvertible {
    var description: String {
        String(value)
    }
}
