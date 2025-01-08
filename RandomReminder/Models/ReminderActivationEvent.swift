//
//  ReminderActivationEvent.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation

enum ReminderActivationEvent: Codable {
    case audioFile(URL)
    case popover
    case notification
}
