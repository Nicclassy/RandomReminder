//
//  ReminderCounts.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct ReminderCounts: Codable {
    var occurences: Int
    var totalOccurences: Int
    
    init(occurences: Int, totalOccurences: Int) {
        self.occurences = occurences
        self.totalOccurences = totalOccurences
    }
    
    init(totalOccurences: Int) {
        self.init(occurences: 0, totalOccurences: totalOccurences)
    }
    
    var occurencesLeft: Int {
        self.totalOccurences - self.occurences
    }
}
