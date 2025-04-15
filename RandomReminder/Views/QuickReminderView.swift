//
//  QuickReminderView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

struct QuickReminderView: View {
    @State private var earliestDate: Date
    @State private var latestDate: Date
    @StateObject private var quickReminderManager = QuickReminderManager()
    
    @ObservedObject private var appPreferences: AppPreferences = .shared
    private var reminderManager: ReminderManager = .shared
    
    var body: some View {
        VStack(spacing: -25) {
            DualDatePickerView(
                earliestHeading: L10n.TimePicker.EarliestTime.heading,
                latestHeading: L10n.TimePicker.LatestTime.heading,
                displayedComponents: .hourAndMinute,
                earliestDate: $earliestDate,
                latestDate: $latestDate
            )
            .border(.blue)
            HStack {
                Spacer()
                Button(quickReminderManager.quickReminderStarted ? "Stop" : "Start") {
                    quickReminderManager.toggleStarted()
                }
                .border(.red)
                .padding()
            }
        }
        .frame(width: 200, height: 150)
        .border(.purple)
        .padding()
    }
    
    init(earliestDate: Date = Date(), latestDate: Date? = nil) {
        self.earliestDate = earliestDate
        self.latestDate = latestDate ?? earliestDate.addMinutes(1)
    }
}

#Preview {
    QuickReminderView()
}
