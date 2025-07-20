//
//  GeneralPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/12/2024.
//

import LaunchAtLogin
import SwiftUI

struct GeneralPreferencesView: View {
    @ObservedObject var appPreferences: AppPreferences = .shared

    var body: some View {
        Form {
            Section {
                Toggle(isOn: appPreferences.$launchAtLogin) {
                    Text(L10n.Preferences.General.launchAtLogin)
                    CaptionText(L10n.Preferences.General.LaunchAtLogin.caption)
                }
                .onChange(of: appPreferences.launchAtLogin) { _, isEnabled in
                    LaunchAtLogin.isEnabled = isEnabled
                }
            }

            Section {
                Toggle(isOn: appPreferences.$quickReminderEnabled) {
                    Text(L10n.Preferences.General.quickReminderEnabled)
                    CaptionText(L10n.Preferences.General.QuickReminderEnabled.caption)
                }
                .onChange(of: appPreferences.quickReminderEnabled) { _, isEnabled in
                    FancyLogger.info("Quick reminder was \(isEnabled ? "not" : "") enabled")
                }
            }

            Section {
                Toggle(isOn: appPreferences.$showReminderCounts) {
                    Text("Show reminder counts")
                    CaptionText("Show the number of reminders in each category in the category's heading.")
                }
                .onChange(of: appPreferences.showReminderCounts) { _, showReminderCount in
                    appPreferences.showReminderCounts = showReminderCount
                }
            }

            Section {
                Toggle(isOn: appPreferences.$randomiseAudioPlaybackStart) {
                    Text("Randomise audio playback start")
                    CaptionText("Start reminder audio playback from a random point in reminders' files.")
                }
            }

            Spacer().frame(height: 10)

            Section {
                Text("Time Format").padding(.leading, 20)
                Picker("", selection: appPreferences.$timeFormat) {
                    Text("hours, minutes, seconds").tag(TimeFormat.long)
                    Text("hrs, mins, secs").tag(TimeFormat.medium)
                    Text("h, m, s").tag(TimeFormat.short)
                }
                .pickerStyle(RadioGroupPickerStyle())
                .onChange(of: appPreferences.timeFormat) {
                    FancyLogger.info("Posting refresh modification window notification")
                    ReminderModificationController.shared.postRefreshModificationWindowNotification()
                }
            }
        }
        .frame(width: 320, height: 300)
    }
}

#Preview {
    GeneralPreferencesView()
}
