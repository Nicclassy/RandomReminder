//
//  SchedulePreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 5/1/2025.
//

import SwiftUI

struct SchedulePreferencesView: View {
    @EnvironmentObject var appPreferences: AppPreferences
    
    var defaultEarliestDate: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: intervalOrDefault(appPreferences.defaultEarliestDate, or: Date.startOfDay())) },
            set: { appPreferences.defaultEarliestDate = $0.timeIntervalSince1970 }
        )
    }
        
    var defaultLatestDate: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: intervalOrDefault(appPreferences.defaultLatestDate, or: Date.endOfDay())) },
            set: { appPreferences.defaultLatestDate = $0.timeIntervalSince1970 }
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
        }
        .frame(width: 300, height: 250)
    }
    
    private func intervalOrDefault(_ interval: TimeInterval, or date: @autoclosure () -> Date) -> TimeInterval {
        interval == 0 ? date().timeIntervalSince1970 : interval
    }
}

#Preview {
    SchedulePreferencesView()
        .environmentObject(AppPreferences.shared)
}
