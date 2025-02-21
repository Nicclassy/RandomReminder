//
//  ReminderActivationEvent.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import Foundation
import AppKit

protocol ReminderActivationEvent: Codable {
    func show(for reminder: RandomReminder)
}

final class ReminderAlert: ReminderActivationEvent {
    func show(for reminder: RandomReminder) {
        let alert = NSAlert()
        alert.messageText = reminder.content.title
        alert.informativeText = reminder.content.text
        alert.alertStyle = .informational
        alert.runModal()
    }
}

final class ReminderNotification: ReminderActivationEvent {
    func show(for reminder: RandomReminder) {}
}

final class ReminderAudioFile: ReminderActivationEvent {
    let name: String
    let url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
    
    func show(for reminder: RandomReminder) {}
}

extension ReminderAudioFile: Equatable, Hashable {
    static func == (lhs: ReminderAudioFile, rhs: ReminderAudioFile) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
