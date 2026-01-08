//
//  ReminderContent.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

enum ReminderDescription: Codable {
    static let emptyText: Self = .text("")

    case text(String)
    case command(String, generatesTitle: Bool)
}

struct ReminderContent: Codable {
    var title: String
    var description: ReminderDescription
}
