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

    @State private var command: String = "ping 127.0.0.1" // python3 -c \"print('Hello World')\"
    @State private var process: DescriptionProcess = .init()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter the command to be executed when the reminder occurs:")
            TextField("", text: $command).font(Self.codeFont)
            ScrollView { output }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(NSColor.textBackgroundColor))

            HStack {
                Button("Save") {}
                    .buttonStyle(.borderedProminent)
                Button("Cancel") {}
                Spacer()
                Button("Run") {
                    Task(priority: .userInitiated) {
                        var subprocess = Subprocess(command: command)
                        FancyLogger.info("Executing command '\(command)'")
                        let result = subprocess.run()
                        FancyLogger.info("Result: \(result)")

                        await MainActor.run { [subprocess] in
                            FancyLogger.info("Command output: \(subprocess.stdout)")
                            FancyLogger.info("Command errors: \(subprocess.stderr)")
                            if !subprocess.stderr.isEmpty {
                                process = DescriptionProcess(output: subprocess.stdout, result: .error(subprocess.stderr))
                            } else {
                                process = DescriptionProcess(output: subprocess.stdout, result: result)
                            }
                        }
                    }
                }
                Button(
                    action: {
                        command = ""
                        process = .init()
                    },
                    label: {
                        Image(systemName: "trash")
                    }
                )
            }
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
}

#Preview {
    ReminderDescriptionView()
}
