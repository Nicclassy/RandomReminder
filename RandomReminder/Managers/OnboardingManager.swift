//
//  OnboardingManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 10/1/2026.
//

import Foundation

final class OnboardingManager {
    static let shared = OnboardingManager()

    private(set) lazy var shouldShowOnboarding = !AppPreferences.shared.onboardingComplete

    func setup() {
        if AppPreferences.shared.onboardingComplete {
            NotificationPermissions.shared.promptIfAlertsNotEnabled()
        }
    }

    func forceOnboarding() {
        shouldShowOnboarding = true
    }

    func onCompletion() {
        AppPreferences.shared.onboardingComplete = true
    }
}
