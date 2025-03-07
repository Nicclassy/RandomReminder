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
    
    lazy var activeReminders: [ActiveReminderService] = {
       return []
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
        reminders.lazy.filter { !$0.hasPast }.sorted { $0.compare(with: $1) }
    }
    
    func pastReminders() -> [RandomReminder] {
        reminders.lazy.filter { $0.hasPast }.sorted { $0.compare(with: $1) }
    }

    func nextAvailableId() -> ReminderID {
        (.firstAvailableId...).first { !reminderIds.contains($0) }!
    }
    
    func addReminder(_ reminder: RandomReminder) {
        reminders.append(reminder)
        reminderIds.insert(reminder.id)
        ReminderSerializer.save(reminder, filename: reminder.filename())
    }
    
    func removeReminder(_ reminder: RandomReminder) {
        let index = reminders.firstIndex(of: reminder)!
        reminders.remove(at: index)
        reminderIds.remove(reminder.id)
        stopReminderIfActive(reminder)
        deleteReminder(reminder)
    }
    
    func startReminder(_ reminder: RandomReminder) {}
    
    static func previewReminders() -> [RandomReminder] {
        [
            RandomReminder(id: 1, title: "Take a 5 minute break", text: "Why", interval: ReminderDateInterval(earliestDate: Date().addMinutes(1), latestDate: Date().addMinutes(2)), totalOccurences: 2),
            RandomReminder(id: 2, title: "Random acts of kindness", text: "A reminder", interval: ReminderTimeInterval.infinite, totalOccurences: 3),
            RandomReminder(id: 3, title: "Make progress on RandomReminder", text: "Things", interval: ReminderDateInterval(earliestDate: Date().addMinutes(120), latestDate: Date().addMinutes(120)), totalOccurences: 2),
            RandomReminder(id: 4, title: "Posture check", text: "Some things", interval: ReminderDateInterval(earliestDate: Date().subtractMinutes(1), latestDate: Date().addMinutes(20)), totalOccurences: 5),
            RandomReminder(id: 5, title: "Do some programming", text: "Waaa", interval: ReminderDateInterval(earliestDate: Date().subtractMinutes(5), latestDate: Date().subtractMinutes(4)), totalOccurences: 3),
            RandomReminder(id: 6, title: "Check on wellbeing", text: "Boring", interval: ReminderDateInterval(earliestDate: Date().subtractMinutes(20), latestDate: Date().subtractMinutes(19)), totalOccurences: 14)
        ]
    }
    
    private func stopReminderIfActive(_ reminder: RandomReminder) {
        if let activeReminder = activeReminders.first(where: { $0.reminder.id == reminder.id }) {
            activeReminder.stop()
        }
    }
    
    private func deleteReminder(_ reminder: RandomReminder) {
        let url = StoredReminders.url.appendingPathComponent(reminder.filename())
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            FancyLogger.error("Error removing file:", error)
        }
    }
    
    private static func reminderFileNames() -> [String] {
        let filenames = try! FileManager.default.contentsOfDirectory(atPath: StoredReminders.url.path())
        return filenames.filter { StoredReminders.filenamePattern.contains(captureNamed: $0) }
    }
}
