//
//  ReminderTimer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation

struct ReminderTimer {
    var startTime: TimeOnly
    var endTime: TimeOnly
    var reminderCount: Int
    
    init(from startDate: Date, to endDate: Date, reminderCount: Int) {
        self.startTime = TimeOnly(from: startDate)
        self.endTime = TimeOnly(from: endDate)
        self.reminderCount = reminderCount
    }
}
