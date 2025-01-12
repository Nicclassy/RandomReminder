//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import Foundation

class ReminderManager: ObservableObject {
    @Published var reminders: [RandomReminder]
    
    init(_ reminders: [RandomReminder]) {
        self.reminders = reminders
    }
    
    convenience init() {
        let path = StoredReminders.documentsUrl.path()
        let files = try! FileManager.default.contentsOfDirectory(atPath: path)
        let reminders: [RandomReminder] = files.compactMap { filename in
            StoredReminders.filenameFormat.contains(captureNamed: filename)
                ? ReminderSerializer.load(filename: filename)
                : nil
        }
        self.init(reminders)
    }
}
