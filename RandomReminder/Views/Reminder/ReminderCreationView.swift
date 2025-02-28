//
//  ReminderCreationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

struct ReminderCreationView: View {
    @StateObject var reminderManager: ReminderManager = .shared
    @StateObject var reminder = ReminderBuilder()
    @StateObject var preferences = ReminderPreferences()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create new reminder")
                .font(.title2)
            Text("Reminder title:")
            TextField("Title", text: $reminder.title)
            
            Text("Reminder description:")
            TextField("Description", text: $reminder.text)
            
            ReminderSchedulePreferencesView(reminder: reminder, preferences: preferences)
            ReminderDayPreferencesView(reminder: reminder, preferences: preferences)
            ReminderAudioPreferencesView(reminder: reminder, preferences: preferences)
                .padding(.bottom, 15)
            
            HStack {
                Button(action: {}) {
                    Text("Cancel")
                        .frame(width: 60)
                }
                Button(action: {}) {
                    Text("Create")
                        .frame(width: 60)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(width: 500, height: 600)
        .padding()
    }
}

#Preview {
    ReminderCreationView()
}
