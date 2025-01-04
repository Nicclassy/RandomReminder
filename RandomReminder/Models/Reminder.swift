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

struct Reminder: Codable, CustomStringConvertible {
    var id: Int = reminderID()
    var title: String
    var text: String
    var audioFile: URL?
    var earliestDate: Date
    var latestDate: Date
    var timesReminded: Int
    var totalReminders: Int
    var enabled: Bool
    
    var description: String {
        self.title
    }
    
    func durationInSeconds() -> Float {
        Float(self.earliestDate.distance(to: self.latestDate))
    }
    
    mutating func activate() {
        self.timesReminded += 1
    }
    
    mutating func set() {
        self.earliestDate = self.earliestDate.sameTimeToday()!
        self.latestDate = self.latestDate.sameTimeToday()!
        
    }
    
    mutating func reset() {
        self.timesReminded = 0
    }
}
