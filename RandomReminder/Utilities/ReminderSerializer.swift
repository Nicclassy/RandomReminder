//
//  ReminderSerializer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation
import SwiftUI

final class ReminderSerializer {
    static func load<T: Codable>(filename: String) -> T? {
        if let data = try? Data(contentsOf: StoredReminders.documentsUrl.appendingPathComponent(filename)) {
            try? JSONDecoder().decode(T.self, from: data)
        } else {
            nil
        }
    }
    
    static func save<T: Codable>(_ value: T, filename: String) {
        guard let data = try? JSONEncoder.applicationDefault().encode(value) else {
            return
        }
        
        do {
            try data.write(to: StoredReminders.documentsUrl.appendingPathComponent(filename), options: .atomic)
        } catch let error {
            FancyLogger.warn("Error writing reminder data:", error)
        }
    }
}
