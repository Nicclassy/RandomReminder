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
    @StateObject private var appPreferences = AppPreferences()
    
    init(earliestDate: Date = Date(), latestDate: Date? = nil) {
        self.earliestDate = earliestDate
        self.latestDate = latestDate ?? earliestDate.addMinutes(1)
    }
    
    var body: some View {
        VStack(spacing: -20) {
            DualTimePickerView(
                earliestDate: $earliestDate,
                latestDate: $latestDate
            )
            HStack {
                Spacer()
                Button(appPreferences.quickReminderStarted ? "Stop" : "Start") {
                    appPreferences.quickReminderStarted.toggle()
                }
                .padding()
            }
        }
        .frame(width: 200, height: 150)
        .padding()
    }
}

#Preview {
    QuickReminderView()
}
