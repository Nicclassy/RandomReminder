//
//  GeneralPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/12/2024.
//

import LaunchAtLogin
import SwiftUI

struct GeneralPreferencesView: View {
    @ObservedObject private var appPreferences: AppPreferences = .shared

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
                Toggle(isOn: appPreferences.$showReminderCounts) {
                    Text(L10n.Preferences.General.showReminderCounts)
                    CaptionText(L10n.Preferences.General.ShowReminderCounts.caption)
                }
                .onChange(of: appPreferences.showReminderCounts) { _, showReminderCount in
                    appPreferences.showReminderCounts = showReminderCount
                }
            }

            Section {
                Toggle(isOn: appPreferences.$randomiseAudioPlaybackStart) {
                    Text(L10n.Preferences.General.randomiseAudioPlayback)
                    CaptionText(L10n.Preferences.General.RandomiseAudioPlayback.caption)
                }
            }

            Section {
                Toggle(isOn: appPreferences.$singleModificationView) {
                    Text("Reminder modification is one screen")
                    CaptionText(multilineString {
                        "If disabled, reminder modification will "
                        "be split into two different screens"
                    })
                }
            }

            Spacer().frame(height: 10)

            Section {
                Text(L10n.Preferences.General.timeFormat).padding(.leading, 20)
                Picker("", selection: appPreferences.$timeFormat) {
                    Text(L10n.Preferences.General.TimeFormat.long).tag(TimeFormat.long)
                    Text(L10n.Preferences.General.TimeFormat.medium).tag(TimeFormat.medium)
                    Text(L10n.Preferences.General.TimeFormat.short).tag(TimeFormat.short)
                }
                .pickerStyle(.radioGroup)
                .onChange(of: appPreferences.timeFormat) {
                    ReminderModificationController.shared.refreshModificationWindow()
                }
            }
        }
        .frame(width: 320, height: 300)
    }
}

#Preview {
    GeneralPreferencesView()
}
