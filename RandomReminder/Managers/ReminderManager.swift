//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import Foundation
import SwiftUI

final class ReminderManager: ObservableObject {
    static let shared = ReminderManager()
    
    @Published var reminders: [RandomReminder]
    
    lazy var reminderIds: Set<ReminderID> = {
        let ids: [ReminderID] = Self.reminderFileNames().compactMap { filename in
            guard let match = try? StoredReminders.filenamePattern.firstMatch(in: filename),
                let filenameId = Int(filename[match.range])
            else {
                FancyLogger.warn("Filename \(filename) is being skipped because it contains no valid regex matches")
                return nil
            }
            
            return ReminderID(filenameId)
        }
        
        return Set(ids)
    }()
    
    init(_ reminders: [RandomReminder]) {
        self.reminders = reminders
    }
    
    convenience init() {
        let reminders: [RandomReminder] = Self.reminderFileNames().compactMap { filename in
            if let reminder: RandomReminder = ReminderSerializer.load(filename: filename) {
                return reminder
            } else {
                FancyLogger.warn("Reminder with filename \(filename) was not loaded")
                return nil
            }
        }
        
        self.init(reminders)
    }
    
    var quickReminder: RandomReminder? {
        return reminders.first { $0.id == ReminderID.quickReminderId }
    }
    
    func nextAvailableId() -> ReminderID {
        (ReminderID.firstAvailableId...).first { !reminderIds.contains($0) }!
    }
    
    func addReminder(_ reminder: RandomReminder) {
        self.reminders.append(reminder)
        self.reminderIds.insert(reminder.id)
    }
    
    func removeReminder(_ reminder: RandomReminder) {
        let index = self.reminders.firstIndex(of: reminder)!
        self.reminders.remove(at: index)
        self.reminderIds.remove(reminder.id)
    }
    
    static func reminderFileNames() -> [String] {
        let filenames = try! FileManager.default.contentsOfDirectory(atPath: StoredReminders.url.path())
        return filenames.filter { StoredReminders.filenamePattern.contains(captureNamed: $0) }
    }
}
