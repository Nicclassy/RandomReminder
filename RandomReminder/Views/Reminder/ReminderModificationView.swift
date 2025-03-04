//
//  ReminderModificationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

enum ReminderModificationMode {
    case create
    case edit
}

struct ReminderModificationView: View {
    @StateObject var reminderManager: ReminderManager = .shared
    @StateObject var reminder: ReminderBuilder
    @StateObject var preferences: ReminderPreferences
    var mode: ReminderModificationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(heading).font(.title2)
            Grid(alignment: .leading) {
                GridRow {
                    Text("Reminder title:")
                    TextField("Title", text: $reminder.title)
                }
                GridRow {
                    Text("Reminder description:")
                    TextField("Description", text: $reminder.text)
                }
                GridRow {
                    Text("Occurences:")
                    StepperTextField(value: $reminder.totalOccurences, range: totalRemindersRange)
                        .frame(width: 55)
                }
            }
            
            ReminderSchedulePreferencesView(reminder: reminder, preferences: preferences)
            ReminderAudioPreferencesView(reminder: reminder, preferences: preferences, useAudioFile: $preferences.useAudioFile)
            
            HStack {
                Button(action: {}) {
                    Text(finishButtonText)
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
    
    private var heading: String {
        mode == .create ? "Create new reminder" : "Edit reminder"
    }
    
    private var finishButtonText: String {
        mode == .create ? "Create" : "Save"
    }

    private var totalRemindersRange: ClosedRange<Int> {
        ReminderConstants.minReminders...ReminderConstants.maxReminders
    }
}

#Preview {
    ReminderModificationView(reminder: .init(), preferences: .init(), mode: .create)
}
