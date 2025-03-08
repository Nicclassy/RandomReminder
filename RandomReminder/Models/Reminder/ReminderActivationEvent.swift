//
//  ReminderActivationEvent.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/1/2025.
//

import AppKit
import AVKit
import UserNotifications

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
    func show(for reminder: RandomReminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.content.title
        content.subtitle = reminder.content.text
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

final class ReminderAudioFile: ReminderActivationEvent {
    let name: String
    let url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
    
    func show(for reminder: RandomReminder) {
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else {
            FancyLogger.error("Could not create an audio player for file \(url)")
            return
        }
        
        audioPlayer.play()
    }
}

extension ReminderAudioFile: Equatable, Hashable {
    static func == (lhs: ReminderAudioFile, rhs: ReminderAudioFile) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
