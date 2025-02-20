//
//  Constants.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import RegexBuilder
import SwiftUI

// An implementation of C#'s null-coalescing assignment operator
infix operator ??=: AssignmentPrecedence

func ??=<T>(lhs: inout T?, rhs: T) {
    lhs = lhs ?? rhs
}

// Negate bindings
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    .init(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = $0 }
    )
}

enum StoredReminders {
    static let fileExtension = "json"
    static let folderName = "reminders"
    static let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent(folderName)
    static let filenamePattern = Regex {
        /^(\d+)\./
        fileExtension
        /$/
    }
}

enum ReminderConstants {
    static let minReminders = 1
    static let maxReminders = 999
    
    static let reminderDayChunkSize = 3
    
    static let numberFormatter = NumberFormatter()
}
