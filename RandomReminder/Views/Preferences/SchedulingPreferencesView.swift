//
//  SchedulePreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 5/1/2025.
//

import SwiftUI

struct SchedulingPreferencesView: View {
    @StateObject var schedulingPreferences: SchedulingPreferences = .shared
    
    var defaultEarliestDate: Binding<Date> {
        Binding(
            get: {
                let timeInterval = intervalOrDefault(
                    interval: schedulingPreferences.defaultEarliestTime,
                    default: Date.startOfDay()
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
                    default: Date.endOfDay()
                )
                return Date(timeIntervalSince1970: timeInterval)
            },
            set: { schedulingPreferences.defaultLatestTime = $0.timeIntervalSince1970 }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DualDatePickerView(
                earliestHeading: L10n.TimePicker.EarliestDefaultTime.heading,
                latestHeading: L10n.TimePicker.LatestDefaultTime.heading,
                displayedComponents: .hourAndMinute,
                earliestDate: defaultEarliestDate,
                latestDate: defaultLatestDate
            )
            
            HStack {
                Text("Notification delay (seconds):")
                Spacer()
                StepperTextField(value: schedulingPreferences.$notificationDelayTime, range: 0...60)
                    .frame(width: 50)
            }
            PreferenceCaption("Reminders never occur simultaneously. Control the delay between one reminder's notification and the next when multiple reminders are scheduled to occur.") // swiftlint:disable:this line_length
        }
        .padding()
        .frame(width: 320, height: 300)
    }
    
    private func intervalOrDefault(interval: TimeInterval, default date: @autoclosure () -> Date) -> TimeInterval {
        interval == 0 ? date().timeIntervalSince1970 : interval
    }
}

#Preview {
    SchedulingPreferencesView()
}
