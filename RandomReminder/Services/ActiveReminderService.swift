//
//  ActiveReminderService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 20/3/2025.
//

import Foundation
import AVFoundation

final class ActiveReminderService {
    let reminder: RandomReminder
    var audioPlayer: AVAudioPlayer!
    
    init(reminder: RandomReminder) {
        self.reminder = reminder
    }
    
    func onNotificationAppear() {
        FancyLogger.info("Notification for reminder '\(reminder.content.title)' appeared")
        playReminderAudio()
    }
    
    func onNotificationDisappear() {
        FancyLogger.info("Reminder '\(reminder.content.title)' disappeared")
        if let audioPlayer = self.audioPlayer {
            audioPlayer.stop()
        }
    }
    
    private func playReminderAudio() {
        guard let audioFile = reminder.activationEvents.audio else { return }
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: audioFile.url) else {
            FancyLogger.warn("Audio player cannot play file '\(audioFile.url)'")
            return
        }
        guard audioPlayer.prepareToPlay() else {
            FancyLogger.warn("System failed to prepare audio player")
            return
        }
        
        self.audioPlayer = audioPlayer
        if AppPreferences.shared.randomiseAudioPlaybackStart {
            audioPlayer.currentTime = .random(in: 0..<audioPlayer.duration)
        }
        audioPlayer.play()
    }
}
