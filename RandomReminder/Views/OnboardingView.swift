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
    var step: OnboardingStep = .welcome {
        willSet {
            if step == .permissions {
                notificationsChecked = true
            }
        }
    }

    var showAlert = false
    var notificationsChecked = false
    var alertTitle = ""
    var alertText = ""

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

    func viewCanAlert() -> Bool {
        step == .permissions
    }

    func alertContent() async -> (String, String)? {
        // Step is always permissions
        await NotificationPermissions.shared.onboardingAlertContent()
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
            "allowing you to focus more on your work "
            "and less on when you'll be reminded to do something."
        })
    }
}

private struct PermissionsView: View {
    @Bindable var viewModel: OnboardingViewModel

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
    @Environment(\.dismissWindow) var dismissWindow

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
                        guard viewModel.viewCanAlert() else {
                            viewModel.moveStepForward()
                            if viewModel.step.isLast {
                                dismissWindow(id: WindowIds.onboarding)
                            }
                            return
                        }

                        Task {
                            guard let (title, message) = await viewModel.alertContent() else {
                                FancyLogger.info("View can alert but no content")
                                viewModel.moveStepForward()
                                return
                            }

                            await MainActor.run {
                                viewModel.showAlert = true
                                viewModel.alertTitle = title
                                viewModel.alertText = message
                            }
                        }
                    },
                    label: {
                        Text(viewModel.primaryButtonText)
                            .frame(width: 70)
                    }
                )
                .buttonStyle(.borderedProminent)
            }
            .alert(
                viewModel.alertTitle,
                isPresented: $viewModel.showAlert,
                actions: {
                    Button("Cancel") {}
                    Button("OK") {
                        viewModel.moveStepForward()
                    }
                    .buttonStyle(.borderedProminent)
                },
                message: {
                    Text(viewModel.alertText)
                }
            )
        }
        .padding(.all, 30)
        .frame(width: 400, height: 450)
    }
}

#Preview {
    OnboardingView()
}
