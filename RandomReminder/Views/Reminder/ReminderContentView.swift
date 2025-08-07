//
//  ReminderContentView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 7/7/2025.
//

import SwiftUI

struct ReminderContentView: View {
    @Environment(\.openWindow) private var openWindow

    private let commandIcon = false
    @ObservedObject var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences
    @ObservedObject var fields: ModificationViewFields

    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text("Reminder title:")
                TextField("Title", text: $reminder.title)
            }
            GridRow {
                Text("Reminder description:")
                HStack {
                    if case let .text(description) = reminder.description {
                        TextField(
                            "Description",
                            text: Binding(
                                get: { description },
                                set: { reminder.description = .text($0) }
                            )
                        )
                    } else {
                        Button("Delete description command") {
                            reminder.description = .text("")
                        }
                    }
                    Spacer()
                    Button(
                        action: {
                            if case .command = reminder.description {
                                ReminderModificationController.shared.editDescriptionCommand(reminder.description)
                            }
                            openWindow(id: WindowIds.descriptionCommand)
                        },
                        label: {
                            if commandIcon {
                                // Looks better than its corresponding SF Symbol
                                Text("⌘")
                            } else {
                                Image(systemName: "terminal")
                            }
                        }
                    )
                }
            }
            GridRow {
                Text("Total occurences:")
                if preferences.nonRandom {
                    StepperTextField(
                        value: .constant(1)
                    )
                    .disabled(true)
                } else {
                    StepperTextField(
                        value: $reminder.totalOccurences,
                        range: reminderOccurencesRange,
                        onTextChange: { text in
                            DispatchQueue.main.async {
                                fields.occurrencesText = text
                            }
                        }
                    )
                    .frame(width: 55)
                }
            }
        }
    }

    private var reminderOccurencesRange: ClosedRange<Int> {
        ReminderConstants.minOccurences...ReminderConstants.maxOccurences
    }
}

#Preview {
    ReminderContentView(reminder: .init(), preferences: .init(), fields: .init())
}
