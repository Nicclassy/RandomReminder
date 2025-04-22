//
//  ReminderAudioOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderAudioOptionsView: View {
    @ObservedObject var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences
    @Binding var useAudioFile: Bool

    private let reminderManager: ReminderManager = .shared
    private let alwaysShowFilePicker = false

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Play audio when the reminder occurs", isOn: $useAudioFile)
                .padding(.bottom, 5)
            HStack {
                let audioFiles = reminderManager.audioFiles
                if alwaysShowFilePicker || !audioFiles.isEmpty {
                    Picker("Audio file", selection: audioFileSelection(audioFiles: audioFiles)) {
                        ForEach(audioFiles, id: \.self) { audioFile in
                            Text(String(describing: audioFile.name)).tag(audioFile)
                        }
                    }
                    .disabled(!useAudioFile)
                    .frame(width: 300)
                    Text("OR")
                }

                Button("Choose an audio file") {
                    preferences.showFileImporter = true
                }.fileImporter(
                    isPresented: $preferences.showFileImporter,
                    allowedContentTypes: [.audio],
                    allowsMultipleSelection: false
                ) { result in
                    if case let .failure(failure) = result {
                        FancyLogger.error(failure)
                    } else if case let .success(success) = result {
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
                .disabled(!useAudioFile)
            }
        }
    }

    private func audioFileSelection(audioFiles: [ReminderAudioFile]) -> Binding<ReminderAudioFile> {
        Binding(
            get: { reminder.activationEvents.audio ?? audioFiles.first! },
            set: { reminder.activationEvents.audio = $0 }
        )
    }
}

#Preview {
    ReminderAudioOptionsView(reminder: .init(), preferences: .init(), useAudioFile: .constant(true))
}
