//
//  ReminderCommandView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 15/6/2025.
//

import SwiftUI

private struct ReminderCommandProcess {
    let output: String
    let result: SubprocessResult
    let hasExecuted: Bool

    init(output: String, result: SubprocessResult, hasExecuted: Bool = true) {
        self.output = output
        self.result = result
        self.hasExecuted = hasExecuted
    }

    init() {
        self.init(output: "", result: .success, hasExecuted: false)
    }
}

struct ReminderCommandView: View {
    private static let defaultCommand = ""
    private static let codeFont: Font = .system(size: 12, design: .monospaced)

    @Environment(\.dismissWindow) private var dismissWindow

    private let controller: CommandController = .shared
    @State private var command = Self.defaultCommand
    @State private var commandType: ReminderCommand = .descriptionCommand
    @State private var process: ReminderCommandProcess = .init()
    @State private var settingsOpen = false
    @State private var generatesTitle = false
    @State private var isFirstCommandRun = true
    @State private var isExecutingCommand = false
    @FocusState private var commandIsFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField("", text: $command).font(Self.codeFont)
                .focused($commandIsFocused)
                .onSubmit {
                    if commandIsFocused {
                        runCommand()
                    }
                }
            ScrollView { commandOutput }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(NSColor.textBackgroundColor))

            HStack {
                Button("Save") {
                    if commandType == .descriptionCommand {
                        let description: ReminderDescription = .command(command, generatesTitle: generatesTitle)
                        controller.set(value: description, for: .descriptionCommand)
                    } else {
                        let activationCommand: ActivationCommand = .init(value: command, isEnabled: true)
                        controller.set(value: activationCommand, for: .activationCommand)
                    }
                    dismissWindow(id: WindowIds.reminderCommand)
                }
                .disabled(command.isEmpty)
                .if(!command.isEmpty) { it in
                    it.buttonStyle(.borderedProminent)
                }

                Button("Cancel") {
                    dismissWindow(id: WindowIds.reminderCommand)
                }
                Spacer()
                Button("Run") {
                    runCommand()
                }
                .disabled(command.isEmpty || isExecutingCommand)

                if commandType == .descriptionCommand {
                    Button(
                        action: {
                            settingsOpen = true
                        },
                        label: {
                            Image(systemName: "gearshape")
                                .popover(isPresented: $settingsOpen) { settingsPopoverView }
                        }
                    )
                }
            }
        }
        .onReceive(.descriptionCommand) { _ in
            let description: ReminderDescription = controller.value(for: .descriptionCommand)
            guard case let .command(newCommand, newGeneratesTitle) = description else {
                FancyLogger.error("Expected a .command, received instead \(description)")
                return
            }

            command = newCommand
            generatesTitle = newGeneratesTitle
            FancyLogger.info("Description command edit")
        }
        .onReceive(.activationCommand) { _ in
            let activationCommand: ActivationCommand = controller.value(for: .activationCommand)
            command = activationCommand.value
            generatesTitle = false
        }
        .onAppear {
            commandType = CommandController.shared.commandType
        }
        .onDisappear {
            reset()
        }
        .padding(20)
        .frame(width: 300, height: 240)
    }

    @ViewBuilder
    private var settingsPopoverView: some View {
        Form {
            Section {
                Toggle(isOn: $generatesTitle) {
                    Text("Command also generates notification title")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Spacer().frame(height: 5)
                    CaptionText(
                        "The first line of the command's output will be used as the reminder's notifications' title."
                    )
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                }
            }

            Group {
                Spacer().frame(height: 10)
                HStack {
                    Button("Done") {
                        settingsOpen = false
                    }
                    .buttonStyle(.borderedProminent)

                    Button(
                        action: {
                            reset()
                        },
                        label: {
                            Image(systemName: "trash")
                        }
                    )
                    .disabled(isExecutingCommand)
                }
            }
            .padding(.leading, 20)
        }
        .frame(width: 200, height: 110)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var commandOutput: some View {
        if !process.hasExecuted {
            EmptyView()
        } else if case let .timeout(seconds) = process.result {
            let unit = TimeInfoProvider.seconds(plural: seconds != 1)
            Text("Command timed out after \(Int(seconds)) \(unit)")
        } else if case let .error(error) = process.result {
            Text(error).foregroundStyle(.red)
        } else if process.output.isEmpty {
            Text("(No output)")
        } else {
            Text(process.output).font(Self.codeFont)
        }
    }

    private var title: String {
        if commandType == .descriptionCommand {
            "Enter a Bash command to generate a description for this reminder:"
        } else {
            "Enter a Bash command to run when the reminder appears:"
        }
    }

    private func runCommand() {
        Task {
            await MainActor.run {
                isExecutingCommand = true
            }

            let (subprocess, result) = await withCheckedContinuation { continuation in
                Task.detached(priority: .userInitiated) {
                    var subprocess = await Subprocess(command: command)
                    let result = subprocess.run()
                    continuation.resume(returning: (subprocess, result))
                }
            }

            await MainActor.run {
                process = if subprocess.hasErrors {
                    ReminderCommandProcess(
                        output: subprocess.stdout,
                        result: .error(subprocess.stderr)
                    )
                } else {
                    ReminderCommandProcess(
                        output: subprocess.stdout,
                        result: result
                    )
                }

                isExecutingCommand = false
            }
        }
    }

    private func reset() {
        command = Self.defaultCommand
        process = .init()
    }
}

#Preview {
    ReminderCommandView()
}
