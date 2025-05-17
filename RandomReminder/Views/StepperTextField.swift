//
//  StepperTextField.swift
//  RandomReminder
//
//  Created by Luca Napoli on 14/2/2025.
//

import SwiftUI

// swiftlint:disable:next file_types_order
struct StepperTextField: View {
    @Binding private var value: Int
    @State private var text: String
    let range: ClosedRange<Int>
    let spacing: CGFloat
    private let onTextChange: ((String) -> Void)?

    var body: some View {
        HStack(spacing: spacing) {
            TextField("", text: $text)
                .onAppear {
                    // The text stays the same otherwise. We want to reset
                    // it to reflect the changes in the reminder
                    text = String(value)
                    onTextChange?(text)
                }
                .onChange(of: text) { oldValue, newValue in
                    defer {
                        FancyLogger.warn("Triggering onTextChange")
                        onTextChange?(text)
                    }

                    guard !newValue.isEmpty else {
                        value = range.lowerBound
                        return
                    }

                    if let numericValue = Int(newValue) {
                        value = constrainValue(numericValue, orElse: value)
                        text = String(value)
                    } else if oldValue.isEmpty {
                        text = oldValue
                    }
                }
            Stepper(
                "",
                onIncrement: {
                    value = constrainValue(value + 1, orElse: value)
                    text = String(value)
                },
                onDecrement: {
                    value = constrainValue(value - 1, orElse: value)
                    text = String(value)
                }
            )
        }
    }

    init(
        value: Binding<Int>,
        range: ClosedRange<Int> = Int.min...Int.max,
        spacing: CGFloat = -5,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self._value = value
        self._text = State(initialValue: String(value.wrappedValue))
        self.range = range
        self.spacing = spacing
        self.onTextChange = onTextChange
    }

    private func constrainValue(_ value: Int, orElse defaultValue: Int) -> Int {
        range.contains(value) ? value : defaultValue
    }
}

private struct StepperTextFieldPreview: View {
    @State private var value = 1
    private let showNumber = false

    var body: some View {
        VStack {
            StepperTextField(value: $value, range: 0...100)
                .frame(width: 50)
            if showNumber {
                Text("Value is \(value)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 120, height: 120)
        .padding()
    }
}

#Preview {
    StepperTextFieldPreview()
}
