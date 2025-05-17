//
//  NumericTextField.swift
//  RandomReminder
//
//  Created by Luca Napoli on 9/5/2025.

import SwiftUI

// swiftlint:disable:next file_types_order
struct NumericTextField: View {
    @Binding private var value: Int
    @State private var text: String
    private let onTextChange: ((String) -> Void)?

    var body: some View {
        VStack {
            TextField("", text: $text)
                .onAppear {
                    text = String(value)
                    onTextChange?(text)
                }
                .onChange(of: text) { oldValue, newValue in
                    defer {
                        onTextChange?(text)
                    }

                    guard !newValue.isEmpty else {
                        value = 0
                        return
                    }

                    if let numericValue = Int(newValue) {
                        text = newValue
                        value = numericValue
                    } else {
                        text = if oldValue.isEmpty {
                            oldValue
                        } else {
                            String(value)
                        }
                    }
                }
        }
    }

    init(_ value: Binding<Int>, onTextChange: ((String) -> Void)? = nil) {
        self._value = value
        self._text = State(initialValue: String(value.wrappedValue))
        self.onTextChange = onTextChange
    }
}

private struct NumericTextFieldPreview: View {
    @State private var number = 0
    private let showNumberValue = true

    var body: some View {
        VStack {
            NumericTextField($number)
            if showNumberValue {
                Text("Value of number: \(number)")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .frame(width: 120, height: 100)
        .padding()
    }
}

#Preview {
    NumericTextFieldPreview()
}
