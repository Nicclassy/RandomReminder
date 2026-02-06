//
//  LaunchView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 5/2/2026.
//

import SwiftUI

struct LaunchView: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        EmptyView()
            .frame(width: 0, height: 0)
            .task {
                if OnboardingManager.shared.shouldShowOnboarding {
                    openWindow(id: WindowIds.onboarding)
                }
            }
    }
}
