//
//  ReminderSchedulePreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderSchedulePreferencesView: View {
    @ObservedObject var reminder: ReminderBuilder
    @ObservedObject var preferences: ReminderPreferences
    
    var totalRemindersRange: ClosedRange<Int> {
        ReminderConstants.minReminders...ReminderConstants.maxReminders
    }
    
    var earliestText: String {
        preferences.timesOnly ? "Earliest time:" : "Earliest date:"
    }
    
    var latestText: String {
        preferences.timesOnly ? "Latest time:" : "Latest date:"
    }
    
    var datePickerComponents: DatePickerComponents {
        preferences.timesOnly ? .hourAndMinute : [.date, .hourAndMinute]
    }
    
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Number of reminders:")
                        StepperTextField(value: $reminder.totalReminders, range: totalRemindersRange)
                            .frame(width: 55)
                    }
                }
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Toggle("Repeating every", isOn: $preferences.repeatingEnabled)
                            .disabled(preferences.alwaysRunning)
                        Picker("", selection: $reminder.repeatInterval) {
                            ForEach(RepeatInterval.allCases, id: \.self) { value in
                                if value != .none {
                                    Text(String(describing: value)).tag(value)
                                }
                            }
                        }
                        .disabled(!preferences.repeatingEnabled)
                        .frame(width: 120)
                    }
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
                    Toggle("Always running", isOn: $preferences.alwaysRunning)
                }
            }
            .padding(.bottom, 10)
            
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
    }
}

#Preview {
    ReminderSchedulePreferencesView(reminder: .init(), preferences: .init())
}
