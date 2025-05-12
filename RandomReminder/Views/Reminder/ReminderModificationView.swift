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
    @Environment(\.dismissWindow) private var dismissWindow
    @StateObject var reminder: MutableReminder
    @StateObject var preferences: ReminderPreferences
    @State private var closeView = false
    private let controller: ReminderModificationController = .shared
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
                    Text("Total occurences:")
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
                        guard let previousReminder = controller.reminder else {
                            fatalError("A reminder should be stored here")
                        }

                        ReminderManager.shared.removeReminder(previousReminder)
                    }

                    withAnimation {
                        ReminderManager.shared.addReminder(newReminder)
                        controller.refreshReminders.toggle()
                    }

                    FancyLogger.info("Created new reminder/edited reminder \(String(reflecting: reminder))")
                    dismissWindow(id: mode == .create ? WindowIds.createReminder : WindowIds.editReminder)

                    controller.modificationWindowOpen = false
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
                    // For some reason, dismissing the window after the alert has closed
                    // or in this closure does not work.
                    // Therefore, it is necessary to close the window itself instead
                    if closeView {
                        NSApp.keyWindow?.close()
                        closeView = false
                    }
                }
            }
        }
        .onAppear {
            guard mode == .edit else { return }
            guard let reminderToEdit = controller.reminder else {
                fatalError("Reminder must be set")
            }
            reminder.copyFrom(reminder: reminderToEdit)
        }
        .onDisappear {
            reminder.reset()
            controller.modificationWindowOpen = false
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
