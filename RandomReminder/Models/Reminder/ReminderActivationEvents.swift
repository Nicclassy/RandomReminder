//
//  ReminderActivationEvents.swift
//  RandomReminder
//
//  Created by Luca Napoli on 21/2/2025.
//

import Foundation

struct ReminderAudioFile: Codable, Equatable, Hashable {
    let name: String
    let url: URL

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

final class ReminderActivationEvents: Codable {
    var audio: ReminderAudioFile?

    init(audio: ReminderAudioFile? = nil) {
        self.audio = audio
    }
}
