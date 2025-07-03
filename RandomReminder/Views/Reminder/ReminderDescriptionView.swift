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
    private static let codeFont: Font = .system(size: 12, design: .monospaced)
    private static let defaultCommand = ""

    @Environment(\.dismissWindow) private var dismissWindow

    @State private var command = Self.defaultCommand
    @State private var process: DescriptionProcess = .init()
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
            ScrollView { output }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(NSColor.textBackgroundColor))

            HStack {
                if command.isEmpty {
                    Button("Save") {}
                        .disabled(true)
                } else {
                    Button("Save") {
                        ReminderModificationController.shared.setDescriptionCommand(command)
                        dismissWindow(id: WindowIds.descriptionCommand)
                    }
                    .buttonStyle(.borderedProminent)
                }
                Button("Cancel") {
                    dismissWindow(id: WindowIds.descriptionCommand)
                }
                Spacer()
                if command.isEmpty {
                    Button("Run") {}
                        .disabled(true)
                } else {
                    Button("Run") {
                        runCommand()
                    }
                    .disabled(isExecutingCommand)
                }
                Button(
                    action: {
                        reset()
                    },
                    label: {
                        Image(systemName: "trash")
                    }
                )
            }
        }
        .onDisappear {
            reset()
        }
        .padding(20)
        .frame(width: 300, height: 200)
    }

    @ViewBuilder
    private var output: some View {
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
