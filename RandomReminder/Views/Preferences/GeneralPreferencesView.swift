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
                ToggleablePreference(
                    title: L10n.Preferences.General.launchAtLogin,
                    caption: L10n.Preferences.General.LaunchAtLogin.caption,
                    isOn: appPreferences.$launchAtLogin
                )
                .onChange(of: appPreferences.launchAtLogin) { _, isEnabled in
                    LaunchAtLogin.isEnabled = isEnabled
                }

                ToggleablePreference(
                    title: L10n.Preferences.General.showReminderCounts,
                    caption: L10n.Preferences.General.ShowReminderCounts.caption,
                    isOn: appPreferences.$showReminderCounts
                )

                ToggleablePreference(
                    title: L10n.Preferences.General.randomiseAudioPlayback,
                    caption: L10n.Preferences.General.RandomiseAudioPlayback.caption,
                    isOn: appPreferences.$randomiseAudioPlaybackStart
                )

                ToggleablePreference(
                    title: "Modify reminders on a single screen",
                    caption: "When disabled, reminder modification is split across two screens.",
                    isOn: appPreferences.$singleModificationView
                )
            }

            Section {
                Text(L10n.Preferences.General.timeFormat)
                    .padding(.top, 1)
                    .padding(.leading, 20)

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

            Section {
                Spacer().frame(maxHeight: .infinity)
            }
        }
        .mediumFrame()
        .padding()
    }
}

#Preview {
    GeneralPreferencesView()
}
