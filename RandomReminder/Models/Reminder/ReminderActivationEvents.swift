//
//  ReminderActivationEvents.swift
//  RandomReminder
//
//  Created by Luca Napoli on 21/2/2025.
//

import Foundation

// ReminderActivationEvent proxy
final class ReminderActivationEvents: Codable {
    var audio: ReminderAudioFile?
    var notification: ReminderNotification?
    var alert: ReminderAlert?
    
    func show(reminder: RandomReminder) {
        audio?.show(for: reminder)
        notification?.show(for: reminder)
        alert?.show(for: reminder)
    }
}
