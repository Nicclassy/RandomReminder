//
//  ReminderDateView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/7/2025.
//

import SwiftUI

struct ReminderDateView: View {
    @ObservedObject var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences
    
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text(earliestText)
                Text(latestText)
            }

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
    ReminderDateView(reminder: .init(), preferences: .init())
}
