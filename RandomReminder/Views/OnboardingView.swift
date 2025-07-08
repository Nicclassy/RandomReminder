//
//  OnboardingView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 7/7/2025.
//

import SwiftUI

private enum OnboardingStep {
    case welcome
    case finished

    mutating func next() {
        self = switch self {
        case .welcome: .finished
        case .finished: .finished
        }
    }

    mutating func previous() {
        self = switch self {
        case .finished: .welcome
        case .welcome: .welcome
        }
    }
}

struct OnboardingView: View {
    @State private var step: OnboardingStep = .welcome

    var body: some View {
        VStack {
            Text(headingText)
                .font(.title)
                .fontWeight(.semibold)

            Spacer()
            HStack {
                Button("Back") {
                    step.previous()
                }
                .buttonStyle(.automatic)
                .disabled(step == .welcome)

                Button(primaryButtonText) {
                    step.next()
                }
                .if(step == .finished) { button in
                    button.buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(.all, 50)
        .frame(width: 400, height: 400)
    }

    var primaryButtonText: String {
        step == .finished ? "Finish" : "Next"
    }

    var headingText: String {
        switch step {
        case .welcome: "Welcome"
        case .finished: "Ready to go!"
        }
    }
}

#Preview {
    OnboardingView()
}
