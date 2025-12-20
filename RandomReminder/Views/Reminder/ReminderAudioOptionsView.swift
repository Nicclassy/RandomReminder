//
//  ReminderAudioOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderAudioOptionsView: View {
    @Bindable var reminder: MutableReminder
    @Bindable var preferences: ReminderPreferences
    @Bindable var viewPreferences: ModificationViewPreferences
    @Binding var useAudioFile: Bool

    private let alwaysShowFilePicker = false

    var body: some View {
        HStack(spacing: ViewConstants.horizontalSpacing) {
            Toggle("Play audio when the reminder occurs", isOn: $useAudioFile)
                .padding(.bottom, 5)
            HStack {
                let audioFiles = availableAudioFiles()
                let showPicker = showPicker(audioFiles: audioFiles)
                if alwaysShowFilePicker || showPicker {
                    Picker("Audio file", selection: audioFileSelection(audioFiles: audioFiles)) {
                        ForEach(audioFiles, id: \.self) { audioFile in
                            Text(String(describing: audioFile.name)).tag(audioFile)
                        }
                    }
                    .disabled(!useAudioFile)
                    .frame(width: 300)
                    Text("OR")
                }

                Button(buttonText(pickerIsShown: showPicker)) {
                    viewPreferences.showFileImporter = true
                }
                .fileImporter(
                    isPresented: $viewPreferences.showFileImporter,
                    allowedContentTypes: [.audio],
                    allowsMultipleSelection: false
                ) { result in
                    if case let .failure(failure) = result {
                        FancyLogger.error(failure)
                    } else if case let .success(success) = result {
                        let file = success.first!
                        reminder.activationEvents.audio = ReminderAudioFile(name: file.lastPathComponent, url: file)
                    }
                }
                .disabled(!useAudioFile)
            }
        }
    }

    private func buttonText(pickerIsShown: Bool) -> String {
        if let audioFile = reminder.activationEvents.audio {
            pickerIsShown ? "Change audio file" : "Change audio file from \(audioFile.name)"
        } else {
            "Choose an audio file"
        }
    }

    private func availableAudioFiles() -> [ReminderAudioFile] {
        var result = ReminderManager.shared.audioFiles
        if let audioFile = reminder.activationEvents.audio {
            result.append(audioFile)
        }
        return result
    }

    private func showPicker(audioFiles: [ReminderAudioFile]) -> Bool {
        if audioFiles.count > 1 {
            return true
        }

        if let audioFile = audioFiles.first, audioFile != reminder.activationEvents.audio {
            return true
        }

        return false
    }

    private func audioFileSelection(audioFiles: [ReminderAudioFile]) -> Binding<ReminderAudioFile> {
        Binding(
            get: { reminder.activationEvents.audio ?? audioFiles.first! },
            set: { reminder.activationEvents.audio = $0 }
        )
    }
}

#Preview {
    ReminderAudioOptionsView(
        reminder: .init(),
        preferences: .init(),
        viewPreferences: .init(),
        useAudioFile: .constant(true)
    )
}
