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
    
    init(earliestDate: Date = Date(), latestDate: Date = Date()) {
        self.earliestDate = earliestDate
        self.latestDate = latestDate
    }
    
    var body: some View {
        DualTimePickerView(
            earliestDate: $earliestDate,
            latestDate: $latestDate
        )
    }
}

#Preview {
    QuickReminderView()
}
