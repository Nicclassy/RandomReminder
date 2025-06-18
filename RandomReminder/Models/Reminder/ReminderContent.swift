//
//  ReminderContent.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

enum ReminderDescription: Codable {
    case text(String)
    case command(String)
}

struct ReminderContent: Codable {
    var title: String
    var description: ReminderDescription
}
