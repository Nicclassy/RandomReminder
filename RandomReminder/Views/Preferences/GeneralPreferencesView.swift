//
//  GeneralPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/12/2024.
//

import SwiftUI
import LaunchAtLogin

struct GeneralPreferencesView: View {
    @StateObject var appPreferences: AppPreferences = .shared
    
    var body: some View {
        Form {
            Section {
                Toggle(isOn: appPreferences.$launchAtLogin) {
                    Text(L10n.Preferences.General.launchAtLogin)
                    PreferenceCaption(L10n.Preferences.General.LaunchAtLogin.caption)
                }
                .onChange(of: appPreferences.launchAtLogin) { _, isEnabled in
                    LaunchAtLogin.isEnabled = isEnabled
                }
            }

            Section {
                Toggle(isOn: appPreferences.$quickReminderEnabled) {
                    Text(L10n.Preferences.General.quickReminderEnabled)
                    PreferenceCaption(L10n.Preferences.General.QuickReminderEnabled.caption)
                }
                .onChange(of: appPreferences.quickReminderEnabled) { _, isEnabled in
                    AppDelegate.shared.toggleQuickReminder(isEnabled: isEnabled)
                }
            }
            
            Section {
                Toggle(isOn: appPreferences.$quickReminderEnabled) {
                    Text("Show reminder counts")
                    PreferenceCaption("Show the number of reminders in each category in the category's heading")
                }
                .onChange(of: appPreferences.showReminderCounts) { _, showReminderCount in
                    appPreferences.showReminderCounts = showReminderCount
                }
            }
        }
        .frame(width: 320, height: 250)
    }
}

#Preview {
    GeneralPreferencesView()
}
