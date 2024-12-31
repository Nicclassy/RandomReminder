//
//  Reminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation

func reminderID() -> Int {
    defer {
        ReminderID.id += 1
    }
    return ReminderID.id
}

class ReminderID {
    static var quickReminder = 0
    static var id = 1
}

struct Reminder: Codable {
    var id: Int = reminderID()
    var title: String
    var text: String?
    var audioFile: URL?
    var earliestDate: Date
    var latestDate: Date
    var reminderCount: Int
    var totalReminders: Int
    var enabled: Bool
}
