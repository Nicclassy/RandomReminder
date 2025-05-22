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
    @State private var stepperClicked = false
    let range: ClosedRange<Int>
    let spacing: CGFloat
    let textFieldWidth: CGFloat
    private let preStepperView: ((Int) -> AnyView)?
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
                        onTextChange?(text)
                    }

                    guard !stepperClicked else {
                        stepperClicked = false
                        return
                    }

                    guard !newValue.isEmpty else {
                        value = range.lowerBound
                        return
                    }

                    if let numericValue = Int(newValue) {
                        value = constrainValue(numericValue, orElse: value)
                        text = String(value)
                    } else {
                        text = if oldValue.isEmpty {
                            oldValue
                        } else {
                            String(value)
                        }
                    }
                }
                .frame(width: textFieldWidth)

            if let preStepperView {
                Spacer().frame(width: spacing)
                preStepperView(value)
            }

            Stepper(
                "",
                onIncrement: {
                    stepperClicked = true
                    value = constrainValue(value + 1, orElse: value)
                    text = String(value)
                },
                onDecrement: {
                    stepperClicked = true
                    value = constrainValue(value - 1, orElse: value)
                    text = String(value)
                }
            )
            .padding(.leading, -5)
        }
    }

    init(
        value: Binding<Int>,
        range: ClosedRange<Int> = Int.min...Int.max,
        spacing: CGFloat = 0,
        textFieldWidth: CGFloat = 35,
        preStepperView: ((Int) -> AnyView)? = nil,
        onTextChange: ((String) -> Void)? = nil
    ) {
        self._value = value
        self._text = State(initialValue: String(value.wrappedValue))
        self.range = range
        self.spacing = spacing
        self.textFieldWidth = textFieldWidth
        self.preStepperView = preStepperView
        self.onTextChange = onTextChange
    }

    private func constrainValue(_ value: Int, orElse defaultValue: Int) -> Int {
        range.contains(value) ? value : defaultValue
    }
}

private struct StepperTextFieldPreview: View {
    @State private var value = 1
    @State private var selection: RepeatInterval = .minute
    private let showNumber = false

    var body: some View {
        VStack {
            StepperTextField(
                value: $value,
                range: 0...100,
                spacing: 0,
                textFieldWidth: 45
            )
            if showNumber {
                Text("Value is \(value)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 240, height: 120)
        .padding()
    }
}

#Preview {
    StepperTextFieldPreview()
}
