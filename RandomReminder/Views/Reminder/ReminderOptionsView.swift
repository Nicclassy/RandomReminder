//
//  ReminderOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderOptionsView: View {
    @Bindable var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences
    @ObservedObject var viewPreferences: ModificationViewPreferences
    @ObservedObject var fields: ModificationViewFields

    var body: some View {
        Group {
            Button("Reminder options...") {
                viewPreferences.showOptionsPopover.toggle()
            }
            .popover(
                isPresented: $viewPreferences.showOptionsPopover,
                arrowEdge: .top
            ) {
                Grid(alignment: .leading) {
                    GridRow {
                        ReminderDayOptionsView(
                            reminder: reminder,
                            preferences: preferences,
                            viewPreferences: viewPreferences
                        )
                        repeatEveryToggle
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    GridRow {
                        Toggle("Always running", isOn: $preferences.alwaysRunning)
                            .disabled(preferences.nonRandom)
                        timesOnlyToggle
                    }

                    GridRow {
                        Toggle("Non-random", isOn: $preferences.nonRandom)
                            .disabled(preferences.alwaysRunning)
                        Toggle("Show in window when active", isOn: $preferences.showWhenActive)
                    }
                }
                .frame(width: ViewConstants.reminderWindowWidth)
                .padding()
            }
        }
    }

    @ViewBuilder
    private var repeatEveryToggle: some View {
        HStack(spacing: 0) {
            Toggle("Repeat", isOn: $preferences.repeatingEnabled)
                .disabled(preferences.alwaysRunning || preferences.nonRandom)

            Picker("", selection: $reminder.repeatIntervalType) {
                ForEach(RepeatIntervalType.allCases, id: \.self) { value in
                    Text(String(describing: value)).tag(value)
                }
            }
            .disabled(!preferences.repeatingEnabled || preferences.alwaysRunning)
            .frame(width: 70)

            Spacer().frame(width: 10)

            NumericTextField($reminder.intervalQuantity) { text in
                DispatchQueue.main.async {
                    fields.intervalQuantityText = text
                }
            }
            .frame(width: 35)
            .disabled(!preferences.repeatingEnabled || preferences.alwaysRunning)

            Picker("", selection: $reminder.repeatInterval) {
                ForEach(RepeatInterval.allCases, id: \.self) { interval in
                    if interval != .never {
                        let intervalName = interval.name(for: reminder.intervalQuantity)
                        Text(intervalName).tag(interval)
                    }
                }
            }
            .disabled(!preferences.repeatingEnabled || preferences.alwaysRunning)
            .frame(width: 90)
        }
    }

    @ViewBuilder
    private var timesOnlyToggle: some View {
        HStack {
            Toggle("Use times only", isOn: $preferences.timesOnly)
                .disabled(preferences.alwaysRunning)
            HelpLink {
                viewPreferences.showTimesOnlyPopover.toggle()
            }
            .popover(isPresented: $viewPreferences.showTimesOnlyPopover) {
                Text("The created reminder will occur daily between the specified times.")
                    .padding()
            }
        }
    }
}

#Preview {
    ReminderOptionsView(
        reminder: .init(),
        preferences: .init(),
        viewPreferences: .init(),
        fields: .init()
    )
}
