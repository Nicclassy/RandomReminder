//
//  ReminderTests.swift
//  RandomReminderTests
//
//  Created by Luca Napoli on 24/1/2026.
//

import Foundation
@testable import RandomReminder
import Testing

// swiftlint:disable function_body_length
@Suite("Reminder", .serialized)
struct ReminderTests {
    @Test
    func idsAreSequential() {
        setupReminderManager()
        let first = createReminder()
        let second = createReminder()
        #expect(second.id.value - 1 == first.id.value)
    }

    @Test
    func reminderIdsAreCorrectlyReassigned() {
        let manager = setupReminderManager()
        let first = createReminder()
        let firstId = first.id
        manager.removeReminder(first)

        let second = createReminder()
        let secondId = second.id
        let differentCreationSameValue = ReminderID(secondId.value, creationDate: Date().addingTimeInterval(1))
        #expect(firstId.value == secondId.value)
        #expect(firstId != differentCreationSameValue)
    }

    @Test
    func intervalEndsHaveNoSeconds() {
        func seconds(_ date: Date) -> Int {
            Calendar.current.component(.second, from: date)
        }

        let reminder = createReminder()
        let earliestSeconds = seconds(reminder.interval.earliest)
        let latestSeconds = seconds(reminder.interval.latest)
        #expect(earliestSeconds == 0 && latestSeconds == 0)

        let infinite = createReminder(with: .init(alwaysRunning: true))
        let infiniteEarliestSeconds = seconds(infinite.interval.earliest)
        let infiniteLatestSeconds = seconds(infinite.interval.latest)
        #expect(infiniteEarliestSeconds == 0 && infiniteLatestSeconds == 0)

        let times = createReminder(with: .init(timesOnly: true))
        let timesEarliestSeconds = seconds(times.interval.earliest)
        let timesLatestSeconds = seconds(times.interval.latest)
        #expect(timesEarliestSeconds == 0 && timesLatestSeconds == 0)

        let notEponymous = createReminder(with: .init(nonRandom: true))
        let notEponymousActivationSeconds = seconds(notEponymous.interval.earliest)
        #expect(notEponymousActivationSeconds == 0)
    }

    @Test
    func remindersAreCorrectlyValidated() {
        func isError(_ result: ValidationResult) -> Bool {
            if case .error = result { true } else { false }
        }

        func isWarning(_ result: ValidationResult) -> Bool {
            if case .warning = result { true } else { false }
        }

        func isSuccess(_ result: ValidationResult) -> Bool {
            if case .success = result { true } else { false }
        }

        let manager = setupReminderManager()
        let preferences = ReminderPreferences()
        let fields = ModificationViewFields()

        fields.occurrencesText = ""
        fields.intervalQuantityText = "1"
        var validator = ReminderValidator(
            reminder: MutableReminder(),
            preferences: preferences,
            fields: fields
        )
        #expect(isError(validator.validate()) == true)

        fields.occurrencesText = "1"
        fields.intervalQuantityText = ""
        preferences.repeatingEnabled = true
        validator = ReminderValidator(
            reminder: MutableReminder(),
            preferences: preferences,
            fields: fields
        )
        #expect(isError(validator.validate()) == true)
        preferences.repeatingEnabled = false

        // Don't want a false error later
        fields.occurrencesText = "1"
        fields.intervalQuantityText = "1"

        let duplicateReminder = MutableReminder()
        duplicateReminder.title = "Reminder title"
        manager.addReminder(duplicateReminder.build(preferences: preferences))

        validator = ReminderValidator(
            reminder: duplicateReminder,
            preferences: preferences,
            fields: fields
        )
        #expect(isWarning(validator.validate()) == true)

        let date = Date()
        let alreadyHappened = MutableReminder()
        alreadyHappened.earliestDate = date.addingTimeInterval(-2000)
        alreadyHappened.latestDate = date.addingTimeInterval(-1000)

        validator = ReminderValidator(
            reminder: alreadyHappened,
            preferences: preferences,
            fields: fields
        )
        #expect(isError(validator.validate()) == true)

        let tooShort = MutableReminder()
        tooShort.repeatIntervalType = .every
        tooShort.repeatInterval = .minute
        tooShort.earliestDate = date
        tooShort.latestDate = date.addingTimeInterval(61)
        preferences.repeatingEnabled = true

        validator = ReminderValidator(
            reminder: tooShort,
            preferences: preferences,
            fields: fields
        )
        #expect(isError(validator.validate()) == true)

        let goldilocksRepeating = tooShort
        goldilocksRepeating.latestDate = date.addingTimeInterval(60)

        validator = ReminderValidator(
            reminder: goldilocksRepeating,
            preferences: preferences,
            fields: fields
        )
        #expect(isSuccess(validator.validate()) == true)

        preferences.repeatingEnabled = false

        validator = ReminderValidator(
            reminder: MutableReminder(),
            preferences: preferences,
            fields: fields
        )
        #expect(isSuccess(validator.validate()) == true)
    }
}

private extension ReminderTests {
    @discardableResult
    func setupReminderManager() -> ReminderManager {
        ReminderManager.setup(
            options: .init(persistentChanges: false, remind: false, preview: false)
        )
    }

    func createReminder(with preferences: ReminderPreferences? = nil) -> RandomReminder {
        let reminder = MutableReminder().build(preferences: preferences ?? .init())
        ReminderManager.shared.addReminder(reminder)
        return reminder
    }
}
