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

// swiftlint:disable:next static_operator
func ??= <T>(lhs: inout T?, rhs: T) {
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

enum ReminderConstants {
    static let minReminders = 1
    static let maxReminders = 999
    
    static let reminderDayChunkSize = 3
    
    static let numberFormatter = NumberFormatter()
}

enum ViewConstants {
    static let upcomingRemindersBeforeScroll: UInt = 3
    static let pastRemindersBeforeScroll: UInt = 2
    static let reminderRowHeight: CGFloat = 57.5
    
    static let reminderWindowWidth: CGFloat = 500
    static let reminderWindowHeight: CGFloat = 350
}

enum WindowIds {
    static let createReminder = "create-reminder"
    static let editReminder = "edit-reminder"
}

enum Constants {
    static let bundleID = "io.nicclassy.RandomReminder"
}
