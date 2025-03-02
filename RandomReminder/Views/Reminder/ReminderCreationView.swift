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
    @State private var useAudioFile = false

    var totalRemindersRange: ClosedRange<Int> {
        ReminderConstants.minReminders...ReminderConstants.maxReminders
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create new reminder")
                .font(.title2)
            Grid(alignment: .leading) {
                GridRow {
                    Text("Reminder title:")
                    TextField("Title", text: $reminder.title)
                }
                GridRow {
                    Text("Reminder description:")
                    TextField("Description", text: $reminder.text)
                }
                HStack {
                    Text("Number of reminders:")
                    StepperTextField(value: $reminder.totalReminders, range: totalRemindersRange)
                        .frame(width: 55)
                }
            }
            
            ReminderSchedulePreferencesView(reminder: reminder, preferences: preferences)
            ReminderAudioPreferencesView(reminder: reminder, preferences: preferences, useAudioFile: $useAudioFile)
            
            HStack {
                Button(action: {}) {
                    Text("Create")
                        .frame(width: 60)
                }
                .buttonStyle(.borderedProminent)
                Button(action: {}) {
                    Text("Cancel")
                        .frame(width: 60)
                }
            }
        }
        .frame(width: 500, height: 600)
        .padding()
    }
}

#Preview {
    ReminderCreationView()
}
