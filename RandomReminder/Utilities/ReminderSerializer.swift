//
//  ReminderSerializer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation
import SwiftUI

struct ReminderSerializer {
    static private let remindersFile = "reminders"
    static private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first?
        .appendingPathComponent(remindersFile)
        .appendingPathExtension("json")
    
    static func load<T: Codable>() -> T? {
        if let url, let data = try? Data(contentsOf: url) {
            try? JSONDecoder().decode(T.self, from: data)
        } else {
            nil
        }
    }
    
    static func save<T: Codable>(reminders: T) {
        guard let url else { return }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let data = try encoder.encode(reminders)
            try data.write(to: url, options: [.atomic])
        } catch let error {
            err("Error serializing reminders:", error)
        }
    }
}
