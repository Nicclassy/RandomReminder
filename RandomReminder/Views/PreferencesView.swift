//
//  PreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/12/2024.
//

import SwiftUI

struct PreferencesView: View {
    private enum PreferenceTabs: Hashable {
        case general
        case reminders
        case about
    }
    
    var body: some View {
        TabView {
            GeneralPreferencesView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(PreferenceTabs.general)
            RemindersPreferencesView()
                .tabItem {
                    Label("Reminders", systemImage: "clock.badge.exclamationmark")
                }
                .tag(PreferenceTabs.reminders)
            AboutPreferencesView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(PreferenceTabs.about)
        }
        .padding()
        .frame(width: 350, height: 250)
    }
}

#Preview {
    PreferencesView()
}
