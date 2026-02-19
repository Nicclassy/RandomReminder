//
//  ReminderInfoProvider.swift
//  RandomReminder
//
//  Created by Luca Napoli on 2/2/2026.
//

import SwiftUI

struct TimeInfoComponent {
    let component: Calendar.Component
    let quantity: Int
    let name: String
}

private enum ComponentsResult {
    case list([TimeInfoComponent])
    case greaterThanMeasurement
}

private enum TimeDifferenceInfoCandidates {
    case localised(String)
    case requiresLocalisation([String])
}

private enum TimeInfoComponentLister {
    private static let orderedCalendarComponents: [Calendar.Component] = [.day, .hour, .minute, .second]
    private static let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]

    static func components(from start: Date, to end: Date) -> ComponentsResult {
        func componentName(_ component: Calendar.Component, for quantity: Int) -> String {
            guard let unit = TimeUnit(rawValue: String(describing: component)) else {
                fatalError("Cannot convert \(component) into a TimeUnit")
            }

            return unit.name(for: quantity)
        }

        let differenceComponents = Calendar.current.dateComponents(
            Self.calendarComponents,
            from: end,
            to: start
        )

        if let days = differenceComponents.day, days >= 7 {
            return .greaterThanMeasurement
        }

        let components: [TimeInfoComponent] = Self.orderedCalendarComponents.compactMap { calendarComponent in
            guard let componentValue = differenceComponents.value(for: calendarComponent), componentValue != 0 else {
                return nil
            }

            let quantity = abs(componentValue)
            let componentName = componentName(calendarComponent, for: quantity)
            return TimeInfoComponent(
                component: calendarComponent,
                quantity: quantity,
                name: componentName
            )
        }

        return .list(components)
    }
}

struct ReminderInfoProvider {
    private static let appPreferences: AppPreferences = .shared

    let reminder: RandomReminder
    let font: NSFont

    private static func timeDifferenceInfo(from components: [TimeInfoComponent]) -> String {
        let separator = AppPreferences.shared.timeFormat == .short ? "" : " "
        return components
            .map { "\($0.quantity)\(separator)\($0.name)" }
            .listing()
    }

    func preferencesInfo(fitting width: CGFloat? = nil) -> String {
        if reminder.hasBegun {
            return if reminder.counts.occurrencesLeft == 1 {
                L10n.Preferences.Reminders.singleOccurrenceLeft
            } else {
                L10n.Preferences.Reminders.multipleOccurrencesLeft(reminder.counts.occurrencesLeft)
            }
        }

        if reminder.hasPast {
            let date = if case let .finalActivation(date) = reminder.activationState {
                date
            } else {
                reminder.interval.latest
            }

            return longestFittingInfo(
                width: width,
                from: date,
                to: .now,
                localise: L10n.Preferences.Reminders.ago
            )
        }

        let start = reminder.interval.earliest
        let candidates = timeDifferenceInfoCandidates(from: start, to: .now)

        switch candidates {
        case let .localised(localised):
            return localised

        case let .requiresLocalisation(candidates):
            return if reminder.eponymous {
                longestFitting(
                    width: width,
                    candidates: candidates,
                    localise: L10n.Preferences.Reminders.startingIn
                )
            } else {
                longestFitting(
                    width: width,
                    candidates: candidates,
                    localise: L10n.Preferences.Reminders.occurringIn
                )
            }
        }
    }

    private func timeDifferenceInfoCandidates(
        from start: Date,
        to end: Date = .now
    ) -> TimeDifferenceInfoCandidates {
        switch TimeInfoComponentLister.components(from: start, to: end) {
        case .greaterThanMeasurement:
            return .localised(L10n.Preferences.Reminders.longerThanOneWeek)

        case let .list(components):
            if components.isEmpty {
                return if reminder.eponymous {
                    .localised(L10n.Preferences.Reminders.startingNow)
                } else if reminder.hasPast {
                    .localised(L10n.Preferences.Reminders.finished)
                } else {
                    .localised(L10n.Preferences.Reminders.occurringNow)
                }
            }

            return .requiresLocalisation(
                (1...components.count)
                    .reversed()
                    .map { count in
                        Self.timeDifferenceInfo(
                            from: Array(components.prefix(count))
                        )
                    }
            )
        }
    }

    private func longestFittingInfo(
        width: CGFloat?,
        from start: Date,
        to end: Date = .now,
        localise: (String) -> String
    ) -> String {
        let candidates = timeDifferenceInfoCandidates(from: start, to: end)

        switch candidates {
        case let .localised(info):
            return info

        case let .requiresLocalisation(candidates):
            return longestFitting(
                width: width,
                candidates: candidates,
                localise: localise
            )
        }
    }

    private func longestFitting(width: CGFloat?, candidates: [String], localise: (String) -> (String)) -> String {
        guard let first = candidates.first, let last = candidates.last else {
            fatalError("Candidates not provided")
        }

        guard let width else {
            return localise(first)
        }

        return candidates
            .map(localise)
            .first(where: { $0.width(with: font) <= width }) ?? last
    }
}
