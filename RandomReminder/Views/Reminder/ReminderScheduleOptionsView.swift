//
//  ReminderScheduleOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderScheduleOptionsView: View {
    @ObservedObject var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences

    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                VStack(alignment: .leading) {
                    ReminderDayOptionsView(reminder: reminder, preferences: preferences)
                    HStack {
                        Toggle("Use times only", isOn: $preferences.timesOnly)
                            .disabled(preferences.alwaysRunning)
                        HelpLink {
                            preferences.showTimesOnlyPopover.toggle()
                        }
                        .popover(isPresented: $preferences.showTimesOnlyPopover) {
                            Text("The created reminder will occur daily between the specified times.")
                                .padding()
                        }
                    }
                }

                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Toggle("Repeat", isOn: $preferences.repeatingEnabled)
                            .disabled(preferences.alwaysRunning)
                        Picker("", selection: $reminder.repeatIntervalType) {
                            ForEach(RepeatIntervalType.allCases, id: \.self) { value in
                                Text(String(describing: value)).tag(value)
                            }
                        }
                        .disabled(!preferences.repeatingEnabled)
                        .frame(width: 70)
                        Spacer().frame(width: 10)
                        NumericTextField($reminder.intervalQuantity)
                            .frame(width: 35)
                            .disabled(!preferences.repeatingEnabled)
                        Picker("", selection: $reminder.repeatInterval) {
                            ForEach(RepeatInterval.allCases, id: \.self) { value in
                                if value != .never {
                                    let intervalName = pluralise(
                                        String(describing: value),
                                        reminder.intervalQuantity
                                    )
                                    Text(intervalName).tag(value)
                                }
                            }
                        }
                        .disabled(!preferences.repeatingEnabled)
                        .frame(width: 90)
                    }
                    Toggle("Always running", isOn: $preferences.alwaysRunning)
                }
            }
            .padding(.bottom, 20)

            GridRow {
                Text(earliestText)
                Text(latestText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            GridRow {
                let picker = DualDatePicker(
                    displayedComponents: datePickerComponents,
                    earliestDate: $reminder.earliestDate,
                    latestDate: $reminder.latestDate
                )
                picker.earliestDatePicker
                    .disabled(preferences.alwaysRunning)
                picker.latestDatePicker
                    .disabled(preferences.alwaysRunning)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 10)
        }
        .frame(width: ViewConstants.reminderWindowWidth)
    }

    private var earliestText: String {
        preferences.timesOnly ? "Earliest time:" : "Earliest date:"
    }

    private var latestText: String {
        preferences.timesOnly ? "Latest time:" : "Latest date:"
    }

    private var datePickerComponents: DatePickerComponents {
        preferences.timesOnly ? .hourAndMinute : [.date, .hourAndMinute]
    }
}

#Preview {
    ReminderScheduleOptionsView(reminder: .init(), preferences: .init())
}
