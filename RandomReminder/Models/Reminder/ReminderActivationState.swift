//
//  ReminderActivationState.swift
//  RandomReminder
//
//  Created by Luca Napoli on 27/1/2026.
//

import Foundation

enum ReminderActivationState: Codable {
    case noActivations
    case lastActivated(Date)
    case finalActivation(Date)
}
