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
            Toggle("Launch at Login", isOn: appPreferences.$launchAtLogin)
                .onChange(of: appPreferences.launchAtLogin) { _, isEnabled in
                    LaunchAtLogin.isEnabled = isEnabled
                }
            PreferenceCaption("Automatically start this app when you login.")
            
            Toggle("Enable quick reminder", isOn: appPreferences.$quickReminderEnabled)
                .onChange(of: appPreferences.quickReminderEnabled) { _, isEnabled in
                    AppDelegate.shared.toggleQuickReminder(isEnabled: isEnabled)
                }
            PreferenceCaption("Show Quick Reminder in the menu bar item's menu.")
        }
        .frame(width: 300, height: 250)
    }
}

#Preview {
    GeneralPreferencesView()
}
