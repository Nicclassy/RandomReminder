//
//  ReminderActivationEvents.swift
//  RandomReminder
//
//  Created by Luca Napoli on 21/2/2025.
//

import Foundation

struct ActivationCommand: Codable {
    static let `default`: Self = .init(value: "", isEnabled: false)

    var value: String
    var isEnabled: Bool
}

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
    var command: ActivationCommand
    var showWhenActive: Bool

    init(
        audio: ReminderAudioFile? = nil,
        command: ActivationCommand = .default,
        showWhenActive: Bool = false
    ) {
        self.audio = audio
        self.command = command
        self.showWhenActive = showWhenActive
    }
}
