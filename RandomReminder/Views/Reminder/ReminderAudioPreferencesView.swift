//
//  ReminderAudioPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderAudioPreferencesView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @ObservedObject var reminder: ReminderBuilder
    @ObservedObject var preferences: ReminderPreferences
    
    private let alwaysShowFilePicker: Bool = true
    
    var body: some View {
        HStack {
            let audioFiles = reminderManager.audioFiles
            if alwaysShowFilePicker || !audioFiles.isEmpty {
                Picker("Audio file", selection: $reminder.activationEvents.audio) {
                    ForEach(audioFiles, id: \.self) { audioFile in
                        Text(String(describing: audioFile.name)).tag(audioFile)
                    }
                }
                .frame(width: 300)
                Text("OR")
            }
            
            Button("Choose an audio file") {
                preferences.showFileImporter = true
            }.fileImporter(isPresented: $preferences.showFileImporter, allowedContentTypes: [.audio], allowsMultipleSelection: false) { result in
                if case .failure(let failure) = result {
                    FancyLogger.error(failure)
                } else if case .success(let success) = result {
                    let file = success.first!
                    let gotAccess = file.startAccessingSecurityScopedResource()
                    
                    if !gotAccess {
                        FancyLogger.warn("No access to selected file")
                        return
                    }
                    
                    defer {
                        file.stopAccessingSecurityScopedResource()
                    }
                    
                    reminder.activationEvents.audio = ReminderAudioFile(name: file.lastPathComponent, url: file)
                }
            }
        }
    }
}

#Preview {
    ReminderAudioPreferencesView(reminder: .init(), preferences: .init())
        .environmentObject(ReminderManager.shared)
}
