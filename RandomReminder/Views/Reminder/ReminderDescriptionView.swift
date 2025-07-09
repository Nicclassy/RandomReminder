//
//  ReminderDescriptionView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 15/6/2025.
//

import SwiftUI

private struct DescriptionProcess {
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

struct ReminderDescriptionView: View {
    static let defaultCommand = ""
    private static let codeFont: Font = .system(size: 12, design: .monospaced)

    @Environment(\.dismissWindow) private var dismissWindow

    @State private var command = Self.defaultCommand
    @State private var process: DescriptionProcess = .init()
    @State private var settingsOpen = false
    @State private var generatesTitle = false
    @State private var isExecutingCommand = false
    @FocusState private var commandIsFocused: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter the Bash command to be executed when this reminder occurs:")
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
                    let descriptionCommand: ReminderDescription = .command(command, generatesTitle: true)
                    ReminderModificationController.shared.setDescriptionCommand(descriptionCommand)
                    dismissWindow(id: WindowIds.descriptionCommand)
                }
                .disabled(command.isEmpty)
                .if(!command.isEmpty) { it in
                    it.buttonStyle(.borderedProminent)
                }

                Button("Cancel") {
                    dismissWindow(id: WindowIds.descriptionCommand)
                }
                Spacer()
                Button("Run") {
                    runCommand()
                }
                .disabled(command.isEmpty || isExecutingCommand)

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
        .onReceive(NotificationCenter.default.publisher(for: .editDescriptionCommand)) { _ in
            let description = ReminderModificationController.shared.descriptionCommand
            guard case let .command(newCommand, newGeneratesTitle) = description else {
                FancyLogger.error("Expected a .command, received instead \(description)")
                return
            }

            command = newCommand
            generatesTitle = newGeneratesTitle
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
                    PreferenceCaption(
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

    private func runCommand() {
        Task {
            await MainActor.run {
                isExecutingCommand = true
            }

            let (subprocess, result) = await withCheckedContinuation { continuation in
                DispatchQueue.global(qos: .userInitiated).async {
                    var subprocess = Subprocess(command: command)
                    let result = subprocess.run()
                    continuation.resume(returning: (subprocess, result))
                }
            }

            await MainActor.run {
                process = if !subprocess.stderr.isEmpty {
                    DescriptionProcess(
                        output: subprocess.stdout,
                        result: .error(subprocess.stderr)
                    )
                } else {
                    DescriptionProcess(
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
    ReminderDescriptionView()
}
