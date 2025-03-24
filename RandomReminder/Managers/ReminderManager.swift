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
    private var persistentChanges: Bool = false
    private var tickInterval: ReminderTickInterval = .seconds(1)
    
    private var activeReminders: [ActiveReminderService] = []
    private var startedReminders: [ReminderActivatorService] = []
    private var remindersQueue = OperationQueue()
    
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
    
    func setup() {
        setReminderStates()
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
        if persistentChanges {
            ReminderSerializer.save(reminder, filename: reminder.filename())
        }
    }
    
    func removeReminder(_ reminder: RandomReminder) {
        guard let index = reminders.firstIndex(of: reminder) else {
            fatalError("Could not find '\(reminder)' when it was expected to be present")
        }
        
        reminders.remove(at: index)
        reminderIds.remove(reminder.id)
        stopReminder(reminder)
        if persistentChanges {
            deleteReminder(reminder)
        }
    }
    
    func activateReminder(_ reminder: RandomReminder) {
        reminder.activate()
        let activeReminder = ActiveReminderService(reminder: reminder)
        activeReminders.append(activeReminder)
        NotificationManager.shared.addReminderNotification(for: activeReminder)
    }
    
    func deactivateReminder(_ reminder: RandomReminder) {
        guard let index = activeReminders.firstIndex(where: { $0.reminder === reminder }) else {
            FancyLogger.warn("Reminder '\(reminder)' is not in the active reminders list when it should be")
            return
        }
        
        activeReminders.remove(at: index)
        FancyLogger.info("Deactivated reminder \(reminder)")
    }
    
    static func previewReminders() -> [RandomReminder] {
        [
            RandomReminder(id: 1, title: "Take a 5 minute break", text: "Why", interval: ReminderDateInterval(earliestDate: Date(), latestDate: Date().addMinutes(1)), totalOccurences: 2)
        ]
    }
    
    private func startReminder(_ reminder: RandomReminder) {
        let reminderActivator = ReminderActivatorService(reminder: reminder, every: tickInterval) { [self] in
            activateReminder(reminder)
            if reminder.counts.occurenceIsFinal {
                reminder.state = .finished
                stopReminder(reminder)
            }
        }
        
        startedReminders.append(reminderActivator)
        remindersQueue.addOperation { [self] in
            while reminderActivator.running {
                Thread.sleep(forTimeInterval: tickInterval.seconds())
                reminderActivator.activate()
            }
            
            FancyLogger.info("Finished reminder '\(reminder)', resetting")
            reminder.reset()
        }
    }
    
    private func stopReminder(_ reminder: RandomReminder) {
        guard let index = startedReminders.firstIndex(where: { $0.reminder === reminder }) else {
            FancyLogger.warn("Reminder '\(reminder)' was not found when it should be present")
            return
        }
        
        startedReminders.remove(at: index)
    }
    
    private func deleteReminder(_ reminder: RandomReminder) {
        let url = StoredReminders.url.appendingPathComponent(reminder.filename())
        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            FancyLogger.error("Error removing file:", error)
        }
    }
    
    private func setReminderStates() {
        // Perform this processing prior to the timer so that we don't
        // start reminders that past before the app launched
        let date = Date()
        reminders.forEach { [self] reminder in
            if reminder.hasEnded(after: date) {
                reminder.state = .finished
                reminder.reset()
            } else if reminder.hasStarted(after: date) {
                reminder.state = .started
                startReminder(reminder)
                assert(reminder.counts.occurences == 0, "Reminder should not have occurrences")
            }
        }
    }
    
    private static func reminderFileNames() -> [String] {
        guard let filenames = try? FileManager.default.contentsOfDirectory(atPath: StoredReminders.url.path()) else {
            fatalError("Could not get reminders' filenames")
        }
        
        return filenames.filter { StoredReminders.filenamePattern.contains(captureNamed: $0) }
    }
}
