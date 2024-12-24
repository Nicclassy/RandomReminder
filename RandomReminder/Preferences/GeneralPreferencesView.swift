//
//  GeneralPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/12/2024.
//

import SwiftUI
import LaunchAtLogin

struct GeneralPreferencesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Launch at Login", isOn: Binding {
                LaunchAtLogin.isEnabled
            } set: {
                LaunchAtLogin.isEnabled = $0
            })
            Text("Automatically starts this app when you login.")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}

#Preview {
    GeneralPreferencesView()
}
