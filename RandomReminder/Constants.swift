//
//  Constants.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import RegexBuilder
import SwiftUI

/// An implementation of C#'s null-coalescing assignment operator
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
    static let minOccurences = 1
    static let maxOccurences = 999

    static let reminderDayChunkSize = 3
}

enum ViewConstants {
    static let preferencesSpacing: CGFloat = 20
    static let upcomingRemindersBeforeScroll: UInt = 3
    static let pastRemindersBeforeScroll: UInt = 2
    static let reminderRowHeight: CGFloat = 57.5

    static let reminderWindowWidth: CGFloat = 550
    static let reminderWindowHeight: CGFloat = 350
}

enum WindowIds {
    static let createReminder = "create-reminder"
    static let editReminder = "edit-reminder"
    static let descriptionCommand = "description-command"
    static let activeReminder = "active-reminder"
}

enum WindowTitles {
    static let createReminder = "Create New Reminder"
    static let editReminder = "Edit Reminder"
    static let descriptionCommand = "Description Command"
    static let activeReminder = "Reminder Active"
}

enum Constants {
    static let bundleID = "io.nicclassy.RandomReminder"
}
