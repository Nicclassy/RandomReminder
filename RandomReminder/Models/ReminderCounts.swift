//
//  ReminderCounts.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct ReminderCounts: Codable {
    var timesReminded: Int
    var totalReminders: Int
    
    init(timesReminded: Int, totalReminders: Int) {
        self.timesReminded = timesReminded
        self.totalReminders = totalReminders
    }
    
    init(totalReminders: Int) {
        self.init(timesReminded: 0, totalReminders: totalReminders)
    }
}
