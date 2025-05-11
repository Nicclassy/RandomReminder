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
    var range: ClosedRange<Int>
    var spacing: CGFloat

    var body: some View {
        HStack(spacing: spacing) {
            TextField("", text: $text)
                .onChange(of: text) { oldValue, newValue in
                    guard !newValue.isEmpty else {
                        value = 0
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
        spacing: CGFloat = -5
    ) {
        self._value = value
        self._text = State(initialValue: String(value.wrappedValue))
        self.range = range
        self.spacing = spacing
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
