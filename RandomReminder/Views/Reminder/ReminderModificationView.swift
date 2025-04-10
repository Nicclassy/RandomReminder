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
    @Environment(\.dismissWindow) var dismissWindow
    @StateObject var reminder: MutableReminder
    @StateObject var preferences: ReminderPreferences
    @State private var closeView = false
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
            
            ReminderScheduleOptionsView(reminder: reminder, preferences: preferences)
            ReminderAudioOptionsView(
                reminder: reminder,
                preferences: preferences,
                useAudioFile: $preferences.useAudioFile
            )
            
            HStack {
                Button(action: {
                    let newReminder = reminder.build(preferences: preferences)
                    if mode == .edit {
                        guard let previousReminder = ReminderModificationController.shared.reminder else {
                            fatalError("A reminder should be stored here")
                        }
                        
                        ReminderManager.shared.removeReminder(previousReminder)
                    }
                    
                    ReminderManager.shared.addReminder(newReminder)
                }, label: {
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
                    isPresented: $preferences.showCancelPopover,
                    actions: {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            closeView = true
                        }
                    },
                    message: {
                        Text("All entered information will be lost.")
                    }
                )
                .onChange(of: closeView) {
                    if closeView {
                        NSApp.keyWindow?.close()
                        closeView = false
                    }
                }
            }
        }
        .onAppear {
            guard mode == .edit else { return }
            guard let reminderToEdit = ReminderModificationController.shared.reminder else {
                fatalError("Reminder must be set")
            }
            reminder.copyFrom(reminder: reminderToEdit)
        }
        .onDisappear {
            reminder.reset()
        }
        .frame(width: ViewConstants.reminderWindowWidth, height: ViewConstants.reminderWindowHeight)
        .padding()
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
