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
            get: { Date(timeIntervalSince1970: intervalOrDefault(interval: appPreferences.defaultEarliestTime, default: Date.startOfDay())) },
            set: { appPreferences.defaultEarliestTime = $0.timeIntervalSince1970 }
        )
    }
        
    var defaultLatestDate: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: intervalOrDefault(interval: appPreferences.defaultLatestTime, default: Date.endOfDay())) },
            set: { appPreferences.defaultLatestTime = $0.timeIntervalSince1970 }
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DualDatePickerView(
                earliestHeading: L10n.TimePicker.EarliestDefaultTime.heading,
                latestHeading: L10n.TimePicker.LatestDefaultTime.heading,
                displayedComponents: .hourAndMinute,
                earliestDate: defaultEarliestDate,
                latestDate: defaultLatestDate,
                enabled: .constant(true)
            )
        }
        .frame(width: 300, height: 250)
    }
    
    private func intervalOrDefault(interval: TimeInterval, default date: @autoclosure () -> Date) -> TimeInterval {
        interval == 0 ? date().timeIntervalSince1970 : interval
    }
}

#Preview {
    SchedulePreferencesView()
        .environmentObject(AppPreferences.shared)
}
