//
//  OnboardingManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 10/1/2026.
//

import Foundation
import SwiftUI

final class OnboardingManager {
    static let shared = OnboardingManager()

    private var forcedOnboarding = false

    var shouldShowOnboarding: Bool {
        forcedOnboarding || !AppPreferences.shared.onboardingComplete
    }

    func setup() {
        if !shouldShowOnboarding {
            NotificationPermissions.shared.promptIfAlertsNotEnabled()
        }
    }

    func forceOnboarding() {
        forcedOnboarding = true
    }

    func onCompletion() {
        AppPreferences.shared.onboardingComplete = true
    }
}
