//
//  GeneralPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/12/2024.
//

import SwiftUI
import LaunchAtLogin

struct GeneralPreferencesView: View {
    @StateObject private var appPreferences = AppPreferences()
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(L10n.Preferences.General.launchAtLogin, isOn: appPreferences.$launchAtLogin)
                .onChange(of: appPreferences.launchAtLogin) { _, isEnabled in
                    LaunchAtLogin.isEnabled = isEnabled
                }
            PreferenceCaption(L10n.Preferences.General.LaunchAtLogin.caption)
            
            Toggle(L10n.Preferences.General.quickReminderEnabled, isOn: appPreferences.$quickReminderEnabled)
                .onChange(of: appPreferences.quickReminderEnabled) { _, isEnabled in
                    AppDelegate.shared.toggleQuickReminder(isEnabled: isEnabled)
                }
            PreferenceCaption(L10n.Preferences.General.QuickReminderEnabled.caption)
        }
        .frame(width: 300, height: 250)
    }
}

#Preview {
    GeneralPreferencesView()
}
