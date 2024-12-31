//
//  ReminderSerializer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation
import SwiftUI

struct ReminderSerializer {
    typealias CodedReminders = [Reminder]
    
    static private let remindersFile = "reminders"
    static private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent(remindersFile)
        .appendingPathExtension("json")
    
    static func load() -> CodedReminders {
        if let url, let data = try? Data(contentsOf: url) {
            (try? JSONDecoder().decode(CodedReminders.self, from: data)) ?? []
        } else {
            []
        }
    }
    
    static func save(reminders: CodedReminders) {
        guard let url, let data = try? JSONEncoder().encode(reminders) else { return }
        do {
            let json = try JSONSerialization.data(withJSONObject: data)
            try json.write(to: url, options: [.atomic])
        } catch {}
    }
}
