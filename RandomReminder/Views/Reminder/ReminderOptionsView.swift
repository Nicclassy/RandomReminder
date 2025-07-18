//
//  ReminderScheduleOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderOptionsView: View {
    @ObservedObject var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences
    @ObservedObject var viewPreferences: ModificationViewPreferences
    @ObservedObject var fields: ModificationViewFields

    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                VStack(alignment: .leading) {
                    ReminderDayOptionsView(
                        reminder: reminder,
                        preferences: preferences,
                        viewPreferences: viewPreferences
                    )
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

                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Toggle("Repeat", isOn: $preferences.repeatingEnabled)
                            .disabled(preferences.alwaysRunning)

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
                    Toggle("Always running", isOn: $preferences.alwaysRunning)
                }
            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: ViewConstants.reminderWindowWidth)
    }
}

#Preview {
    ReminderOptionsView(reminder: .init(), preferences: .init(), viewPreferences: .init(), fields: .init())
}
