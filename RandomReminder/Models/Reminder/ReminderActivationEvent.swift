//
//  ReminderActivationEvent.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation
import AppKit

private func playAudioFile(url: URL) {
    
}

private func displayAlert(for reminder: RandomReminder) {
    let alert = NSAlert()
    alert.messageText = reminder.content.title
    alert.informativeText = reminder.content.text
    alert.alertStyle = .informational
    alert.runModal()
}

private func displayNotification(for reminder: RandomReminder) {
    
}

enum ReminderActivationEvent: Codable {
    case audioFile(URL)
    case alert
    case notification
    
    func show(for reminder: RandomReminder) {
        switch self {
        case .audioFile(let url): playAudioFile(url: url)
        case .alert: displayAlert(for: reminder)
        case .notification: displayNotification(for: reminder)
        }
    }
}
