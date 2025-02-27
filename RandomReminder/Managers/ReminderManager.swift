//
//  ReminderManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 6/1/2025.
//

import Foundation
import SwiftUI

final class ReminderManager: ObservableObject {
    static let shared = ReminderManager(preview: true)
    
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
    
    var audioFiles: [ReminderAudioFile] {
        reminders.compactMap { $0.activationEvents.audio }
    }
    
    init(_ reminders: [RandomReminder]) {
        self.reminders = reminders
    }
    
    convenience init(preview: Bool = false) {
        let reminders: [RandomReminder] = if preview {
            Self.previewReminders()
        } else {
            Self.reminderFileNames().compactMap { filename in
                guard let reminder: RandomReminder = ReminderSerializer.load(filename: filename) else { return nil }
                guard reminder.id != .quickReminderId else { return nil }
                return reminder
            }
        }
        
        self.init(reminders)
    }
    
    func upcomingReminders() -> [RandomReminder] {
        reminders.lazy.filter { !$0.hasPast() }
    }
    
    func pastReminders() -> [RandomReminder] {
        reminders.lazy.filter { $0.hasPast() }
    }

    func nextAvailableId() -> ReminderID {
        (.firstAvailableId...).first { !reminderIds.contains($0) }!
    }
    
    func addReminder(_ reminder: RandomReminder) {
        ReminderSerializer.save(reminder, filename: reminder.filename())
        reminders.append(reminder)
        reminderIds.insert(reminder.id)
    }
    
    func removeReminder(_ reminder: RandomReminder) {
        let index = reminders.firstIndex(of: reminder)!
        reminders.remove(at: index)
        reminderIds.remove(reminder.id)
    }
    
    static func previewReminders() -> [RandomReminder] {
        [
            RandomReminder(id: 1, title: "Defuse", text: "Why", interval: ReminderDateInterval(earliestDate: Date().addMinutes(1), latestDate: Date().addMinutes(2)), totalReminders: 2),
            RandomReminder(id: 2, title: "Hello", text: "A reminder", interval: ReminderTimeInterval.infinite, totalReminders: 3),
            RandomReminder(id: 3, title: "Do some things", text: "Things", interval: ReminderDateInterval(earliestDate: Date().addMinutes(120), latestDate: Date().addMinutes(120)), totalReminders: 2),
            RandomReminder(id: 4, title: "Other", text: "Some things", interval: ReminderDateInterval(earliestDate: Date().subtractMinutes(1), latestDate: Date().addMinutes(20)), totalReminders: 5),
            RandomReminder(id: 5, title: "I already happened", text: "Waaa", interval: ReminderDateInterval(earliestDate: Date().subtractMinutes(5), latestDate: Date().subtractMinutes(4)), totalReminders: 3)
        ]
    }
    
    private static func reminderFileNames() -> [String] {
        let filenames = try! FileManager.default.contentsOfDirectory(atPath: StoredReminders.url.path())
        return filenames.filter { StoredReminders.filenamePattern.contains(captureNamed: $0) }
    }
}
