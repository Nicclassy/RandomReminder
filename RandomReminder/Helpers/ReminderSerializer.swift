//
//  ReminderSerializer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation
import SwiftUI

enum ReminderSerializer {
    static func load<T: Codable>(filename: String) -> T? {
        guard let data = try? Data(contentsOf: StoredReminders.url.appendingPathComponent(filename)) else {
            return nil
        }

        do {
            return try JSONDecoder.applicationDefault().decode(T.self, from: data)
        } catch {
            FancyLogger.error("Error loading reminder data:", error)
            return nil
        }
    }

    static func save(_ value: some Codable, filename: String) {
        guard let data = try? JSONEncoder.applicationDefault().encode(value) else {
            return
        }

        if !FileManager.default.directoryExists(atPath: StoredReminders.url.path()) {
            createRemindersDirectory()
        }

        let saveUrl = StoredReminders.url.appendingPathComponent(filename)
        do {
            try data.write(to: saveUrl, options: .atomic)
            FancyLogger.info("Succesfully saved reminder to \(saveUrl.path())")
        } catch {
            FancyLogger.error("Error saving reminder data:", error)
        }
    }

    private static func createRemindersDirectory() {
        do {
            try FileManager.default.createDirectory(at: StoredReminders.url, withIntermediateDirectories: false)
        } catch {
            FancyLogger.error("Error creating reminders directory:", error)
        }
    }
}
