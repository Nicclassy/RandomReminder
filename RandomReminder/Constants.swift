//
//  Constants.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import RegexBuilder

// An implementation of C#'s null-coalescing assignment operator
infix operator ??=: AssignmentPrecedence

func ??=<T>(lhs: inout T?, rhs: T) {
    lhs = lhs ?? rhs
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
