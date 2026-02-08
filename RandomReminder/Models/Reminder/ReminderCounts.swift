//
//  ReminderCounts.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

struct ReminderCounts: Codable {
    var occurrences: Int
    let totalOccurrences: Int

    var occurrencesLeft: Int {
        totalOccurrences - occurrences
    }

    init(occurrences: Int, totalOccurrences: Int) {
        self.occurrences = occurrences
        self.totalOccurrences = totalOccurrences
    }

    init(totalOccurrences: Int) {
        self.init(occurrences: 0, totalOccurrences: totalOccurrences)
    }
}
