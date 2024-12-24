//
//  TimeOnly.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation

struct TimeOnly {
    var hour: Int
    var minute: Int
    
    init(from date: Date) {
        self.hour = date.hour
        self.minute = date.minute
    }
}
