//
//  ActiveReminderService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 20/3/2025.
//

import AVFoundation
import Foundation

final class ActiveReminderService {
    let reminder: RandomReminder
    private var audioPlayer: AVAudioPlayer!

    init(reminder: RandomReminder) {
        self.reminder = reminder
    }

    func start() {
        FancyLogger.info("Notification for reminder '\(reminder.content.title)' appeared")
        playReminderAudio()
        NotificationCenter.default.post(name: .updateReminderPreferencesText, object: nil)
    }

    func stop() {
        // Reminder mutations
        FancyLogger.info("Reminder '\(reminder.content.title)' disappeared")
        if let audioPlayer {
            audioPlayer.stop()
        }

        ReminderManager.shared.modify(reminder) { reminder in
            reminder.counts.occurences += 1
            if reminder.counts.occurences == reminder.counts.totalOccurences {
                FancyLogger.info("Setting reminder state to finished and resetting occurences")
                reminder.counts.occurences = 0
                reminder.state = reminder.hasRepeats ? .upcoming : .finished
            }
        }

        NotificationCenter.default.post(name: .updateReminderPreferencesText, object: nil)
    }

    private func playReminderAudio() {
        guard let audioFile = reminder.activationEvents.audio else {
            FancyLogger.info("Reminder '\(reminder)' has no audio")
            return
        }

        let url = audioFile.url
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else {
            FancyLogger.warn("Audio player cannot play file '\(url)'")
            return
        }
        guard audioPlayer.prepareToPlay() else {
            FancyLogger.warn("System failed to prepare audio player for '\(url)'")
            return
        }

        self.audioPlayer = audioPlayer
        if AppPreferences.shared.randomiseAudioPlaybackStart {
            audioPlayer.currentTime = .random(in: 0..<audioPlayer.duration)
        }

        guard audioPlayer.play() else {
            FancyLogger.warn("Audio \(url) was not started")
            return
        }

        FancyLogger.info("Playing audio", url)
    }
}
