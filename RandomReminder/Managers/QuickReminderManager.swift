//
//  QuickReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation
import SwiftUI

final class QuickReminderManager: ObservableObject {
    static var defaultQuickReminder: RandomReminder {
        let earliestTime = TimeOnly(timeIntervalSince1970: SchedulingPreferences.shared.defaultEarliestTime)
        let latestTime = TimeOnly(timeIntervalSince1970: SchedulingPreferences.shared.defaultLatestTime)
        let timeInterval = ReminderTimeInterval(earliestTime: earliestTime, latestTime: latestTime, interval: .day)
        return RandomReminder(
            id: ReminderID.quickReminder,
            title: "Quick Reminder",
            text: "",
            interval: timeInterval,
            totalOccurences: 0
        )
    }

    @Published var quickReminder: RandomReminder

    var quickReminderEnabled: Binding<Bool> {
        Binding(
            get: { [unowned self] in
                quickReminder.state == .upcoming
            },
            set: { [unowned self] enabled in
                quickReminder.state = enabled ? .started : .upcoming
            }
        )
    }

    var quickReminderStarted: Bool {
        quickReminder.state == .started
    }

    init(_ quickReminder: RandomReminder? = nil) {
        self.quickReminder = quickReminder ?? Self.defaultQuickReminder
    }

    func save() {
        ReminderSerializer.save(quickReminder, filename: quickReminder.filename())
    }

    func toggleStarted() {
        quickReminder.state = quickReminder.state == .started ? .upcoming : .started
    }
}
