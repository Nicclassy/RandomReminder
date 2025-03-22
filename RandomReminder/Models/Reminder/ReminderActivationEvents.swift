//
//  ReminderActivationEvents.swift
//  RandomReminder
//
//  Created by Luca Napoli on 21/2/2025.
//

import Foundation

// ReminderActivationEvent facade
final class ReminderActivationEvents: Codable {
    var audio: ReminderAudioFile?
    
    init(audio: ReminderAudioFile? = nil) {
        self.audio = audio
    }
}

struct ReminderAudioFile: Codable {
    let name: String
    let url: URL
}

extension ReminderAudioFile: Equatable, Hashable {
    static func == (lhs: ReminderAudioFile, rhs: ReminderAudioFile) -> Bool {
        lhs.url == rhs.url
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
