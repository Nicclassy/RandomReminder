//
//  SchedulingPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 5/1/2025.
//

import SwiftUI

struct SchedulingPreferencesView: View {
    @ObservedObject var schedulingPreferences: SchedulingPreferences = .shared

    var defaultEarliestDate: Binding<Date> {
        Binding(
            get: {
                let timeInterval = intervalOrDefault(
                    interval: schedulingPreferences.defaultEarliestTime,
                    default: .startOfDay()
                )
                return Date(timeIntervalSince1970: timeInterval)
            },
            set: { schedulingPreferences.defaultEarliestTime = $0.timeIntervalSince1970 }
        )
    }

    var defaultLatestDate: Binding<Date> {
        Binding(
            get: {
                let timeInterval = intervalOrDefault(
                    interval: schedulingPreferences.defaultLatestTime,
                    default: .endOfDay()
                )
                return Date(timeIntervalSince1970: timeInterval)
            },
            set: { schedulingPreferences.defaultLatestTime = $0.timeIntervalSince1970 }
        )
    }

    var body: some View {
        Form {
            Section {
                let picker = DualDatePicker(
                    displayedComponents: .hourAndMinute,
                    earliestDate: defaultEarliestDate,
                    latestDate: defaultLatestDate
                )
                
                Toggle(isOn: .constant(true)) {
                    HStack {
                        Text(L10n.TimePicker.EarliestDefaultTime.heading)
                        Spacer()
                        picker.earliestDatePicker
                    }
                }
                
                Toggle(isOn: .constant(true)) {
                    HStack {
                        Text(L10n.TimePicker.LatestDefaultTime.heading)
                        Spacer()
                        picker.latestDatePicker
                    }
                    
                    PreferenceCaption(
                        "If enabled, newly created reminders will have these times as their start/end times."
                    )
                }
            }
            
            Spacer().frame(height: 20)
            
            Section {
                Toggle(isOn: schedulingPreferences.$notificationGapEnabled) {
                    VStack(alignment: .leading) {
                        Text("Allow time between reminders")
                        HStack {
                            Text("Minimum time:")
                                .padding(.trailing, -5)
                            StepperTextField(
                                value: schedulingPreferences.$notificationGapTime,
                                range: 0...999
                            )
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, -10)
                            .disabled(!schedulingPreferences.notificationGapEnabled)
                            
                            Picker("", selection: schedulingPreferences.$notificationGapTimeUnit) {
                                ForEach(RepeatInterval.gapIntervals, id: \.self) { interval in
                                    let intervalName = pluralise(
                                        String(describing: interval),
                                        schedulingPreferences.notificationGapTime
                                    )
                                    Text(intervalName).tag(interval)
                                }
                            }
                            .frame(width: 100)
                            .disabled(!schedulingPreferences.notificationGapEnabled)
                        }
                    }
                    
                    PreferenceCaption(
                        "Reminders never occur simultaneously. Control the time between one reminder's occurence and the next when multiple reminders are scheduled to occur."
                    ) // swiftlint:disable:previous line_length
                }
            }
        }
        .frame(width: 320, height: 300)
        .padding()
    }

    private func intervalOrDefault(interval: TimeInterval, default date: @autoclosure () -> Date) -> TimeInterval {
        interval == 0 ? date().timeIntervalSince1970 : interval
    }
}

#Preview {
    SchedulingPreferencesView()
}
