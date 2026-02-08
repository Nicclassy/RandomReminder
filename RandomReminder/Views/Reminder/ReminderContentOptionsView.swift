//
//  ReminderContentOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 7/7/2025.
//

import SwiftUI

private enum FocusedField: Hashable {
    case title
    case description
    case occurrences
}

struct ReminderContentOptionsView: View {
    @Environment(\.openWindow) private var openWindow

    private let commandIcon = false
    @Bindable var reminder: MutableReminder
    @Bindable var preferences: ReminderPreferences
    @Bindable var fields: ModificationViewFields
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text("Reminder title:")
                TextField("Title", text: $reminder.title)
                    .focused($focusedField, equals: .title)
            }
            GridRow(alignment: .top) {
                Text("Reminder description:")
                if case let .text(description) = reminder.description {
                    ZStack(alignment: .topLeading) {
                        TextEditor(
                            text: Binding(
                                get: { description },
                                set: { reminder.description = .text($0) }
                            )
                        )
                        .focused($focusedField, equals: .description)
                        .font(.system(size: NSFont.systemFontSize))
                        .frame(width: 380, height: 40)
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(.windowBackground)
                                .frame(width: 15)
                        }

                        HStack {
                            Spacer()
                            Button(
                                action: {
                                    if case .command = reminder.description {
                                        CommandController.shared.set(
                                            value: reminder.description,
                                            for: .descriptionCommand
                                        )
                                    }

                                    CommandController.shared.commandType = .descriptionCommand
                                    openWindow(id: WindowIds.reminderCommand)
                                },
                                label: {
                                    if commandIcon {
                                        Text("⌘")
                                    } else {
                                        Image(systemName: "terminal")
                                    }
                                }
                            )
                            .fixedSize()
                        }
                    }
                } else {
                    Button("Delete description command") {
                        reminder.description = .text("")
                    }
                }
            }
            GridRow {
                Text("Total occurrences:")
                if preferences.nonRandom {
                    StepperTextField(value: .constant(1))
                        .disabled(true)
                } else {
                    StepperTextField(
                        value: $reminder.totalOccurrences,
                        range: reminderOccurrencesRange,
                        onTextChange: { text in
                            DispatchQueue.main.async {
                                fields.occurrencesText = text
                            }
                        }
                    )
                    .focused($focusedField, equals: .occurrences)
                    .frame(width: 55)
                }
            }
        }
        .task {
            focusedField = .title
        }
    }

    private var reminderOccurrencesRange: ClosedRange<Int> {
        ReminderConstants.minOccurrences...ReminderConstants.maxOccurrences
    }
}

#Preview {
    ReminderContentOptionsView(reminder: .init(), preferences: .init(), fields: .init())
}
