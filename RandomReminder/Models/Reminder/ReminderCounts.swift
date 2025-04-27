//
//  ReminderCounts.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct ReminderCounts: Codable {
    var occurences: Int
    let totalOccurences: Int

    var occurencesLeft: Int {
        totalOccurences - occurences
    }

    init(occurences: Int, totalOccurences: Int) {
        self.occurences = occurences
        self.totalOccurences = totalOccurences
    }

    init(totalOccurences: Int) {
        self.init(occurences: 0, totalOccurences: totalOccurences)
    }
}
