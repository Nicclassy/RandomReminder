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

struct ReminderActivationEvents: Codable {
    var audio: ReminderAudioFile?
    var showWhenActive: Bool

    init(audio: ReminderAudioFile? = nil, showWhenActive: Bool = false) {
        self.audio = audio
        self.showWhenActive = showWhenActive
    }
}
