//
//  QuickReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/1/2025.
//

import Foundation
import SwiftUI

final class QuickReminderManager: ObservableObject {
    @Published var quickReminder: RandomReminder
    
    init(_ quickReminder: RandomReminder) {
        self.quickReminder = quickReminder
    }
    
    convenience init() {
        self.init(ReminderManager.shared.quickReminder ?? Self.defaultQuickReminder)
    }
    
    static var defaultQuickReminder: RandomReminder {
        let earliestTime = TimeOnly(timeIntervalSince1970: AppPreferences.shared.defaultEarliestTime)
        let latestTime = TimeOnly(timeIntervalSince1970: AppPreferences.shared.defaultLatestTime)
        let timeInterval = ReminderTimeInterval(earliestTime: earliestTime, latestTime: latestTime, interval: .days(1))
        return RandomReminder(
            id: ReminderID.quickReminderId,
            title: "Quick Reminder", text: "",
            interval: timeInterval,
            totalReminders: 0
        )
    }
    
    var quickReminderEnabled: Binding<Bool> {
        Binding(
            get: { [unowned self] in
                quickReminder.state == .enabled
            },
            set: { [unowned self] enabled in
                quickReminder.state = enabled ? .started : .enabled
            }
        )
    }
    
    var quickReminderStarted: Bool {
        quickReminder.state == .started
    }
    
    func save() {
        ReminderSerializer.save(quickReminder, filename: quickReminder.filename())
    }
    
    func toggleStarted() {
        quickReminder.state = quickReminder.state == .started ? .enabled : .started
    }
}
