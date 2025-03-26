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
    @StateObject var reminder: MutableReminder
    @StateObject var preferences: ReminderPreferences
    let mode: ReminderModificationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                    Text("Total Occurences:")
                    StepperTextField(value: $reminder.totalOccurences, range: totalRemindersRange)
                        .frame(width: 55)
                }
            }
            
            ReminderSchedulePreferencesView(reminder: reminder, preferences: preferences)
            ReminderAudioPreferencesView(
                reminder: reminder,
                preferences: preferences,
                useAudioFile: $preferences.useAudioFile
            )
            
            HStack {
                Button(action: {}, label: {
                    Text(finishButtonText)
                        .frame(width: 60)
                })
                .buttonStyle(.borderedProminent)
                Button(action: {
                    preferences.showCancelPopover.toggle()
                }, label: {
                    Text("Cancel")
                        .frame(width: 60)
                })
                .alert(
                    "Are you sure you want to discard this reminder?",
                    isPresented: $preferences.showCancelPopover
                ) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        if mode == .create {
                            ReminderWindowController.shared.closeCreationWindow()
                        } else {
                            ReminderWindowController.shared.closeEditWindow()
                        }
                    }
                } message: {
                    Text("All entered information will be lost.")
                }
            }
        }
        .frame(width: ViewConstants.reminderWindowWidth, height: ViewConstants.reminderWindowHeight)
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
