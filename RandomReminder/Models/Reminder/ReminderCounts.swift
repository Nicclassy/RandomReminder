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

    var occurenceIsFinal: Bool {
        occurences == totalOccurences - 1
    }

    init(occurences: Int, totalOccurences: Int) {
        self.occurences = occurences
        self.totalOccurences = totalOccurences
    }

    init(totalOccurences: Int) {
        self.init(occurences: 0, totalOccurences: totalOccurences)
    }

    mutating func reset() {
        occurences = 0
    }
}
