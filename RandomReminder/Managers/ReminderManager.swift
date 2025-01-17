//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import Foundation

final class ReminderManager: ObservableObject {
    @Published var reminders: [RandomReminder]
    
    init(_ reminders: [RandomReminder]) {
        self.reminders = reminders
    }
    
    convenience init() {
        let files = try! FileManager.default.contentsOfDirectory(atPath: StoredReminders.url.path())
        let reminders: [RandomReminder] = files.compactMap { filename in
            StoredReminders.filenameFormat.contains(captureNamed: filename)
                ? ReminderSerializer.load(filename: filename)
                : nil
        }
        self.init(reminders)
    }
}
