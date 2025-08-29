//
//  OnboardingView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 7/7/2025.
//

import SwiftUI
import UserNotifications

@Observable
private final class OnboardingViewModel {
    var step: OnboardingStep = .welcome
    var showAlert = false

    var primaryButtonText: String {
        step == .finished ? "Finish" : "Next"
    }

    var headingText: String {
        switch step {
        case .welcome: "Welcome"
        case .permissions: "Notification Permissions"
        case .finished: "Ready to go!"
        }
    }

    func moveStepBackward() {
        step.backward()
    }

    func moveStepForward() {
        step.forward()
    }
}

private enum OnboardingStep: Traversable {
    case welcome
    case permissions
    case finished
}

private struct WelcomeView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        Text(multilineString {
            "Thank you for downloading RandomReminder!\n\n"
            "RandomReminder solves the classic problem of predictable, mundane reminders, "
            "allowing you to focus more on your work."
        })
    }
}

private struct PermissionsView: View {
    @Bindable var viewModel: OnboardingViewModel
    @State private var buttonIsProminent = true
    @State private var alertTitle = ""
    @State private var alertText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(multilineString {
                "RandomReminder requires enabling notification permissions "
                "to work properly. You are strongly recommended to enable 'Alerts', "
                "otherwise the app will not function optimally."
            })
            HStack {
                Spacer()
                Button("Open notification permissions") {
                    NotificationPermissions.shared.openNotificationSettings()
                }
                Spacer()
            }
            .if(buttonIsProminent) { it in
                it.buttonStyle(.borderedProminent)
            }
        }
        .alert(
            alertTitle,
            isPresented: $viewModel.showAlert
        ) {
            Text(alertText)
        }
    }
}

private struct FinishedView: View {
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        Text("You did it!")
    }
}

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack {
            Text(viewModel.headingText)
                .font(.title)
                .fontWeight(.semibold)

            Group {
                switch viewModel.step {
                case .welcome: WelcomeView(viewModel: viewModel)
                case .permissions: PermissionsView(viewModel: viewModel)
                case .finished: FinishedView(viewModel: viewModel)
                }
            }
            .padding([.bottom, .top], 5)

            Spacer()

            HStack {
                Button(
                    action: {
                        viewModel.moveStepBackward()
                    },
                    label: {
                        Text("Back")
                            .frame(width: 70)
                    }
                )
                .buttonStyle(.automatic)
                .disabled(viewModel.step.isFirst)
                Spacer()
                
                Button(
                    action: {
                        viewModel.moveStepForward()
                    },
                    label: {
                        Text(viewModel.primaryButtonText)
                            .frame(width: 70)
                    }
                )
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.all, 30)
        .frame(width: 400, height: 450)
    }
}

#Preview {
    OnboardingView()
}
