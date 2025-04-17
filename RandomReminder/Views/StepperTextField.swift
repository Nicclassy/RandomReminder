//
//  StepperTextField.swift
//  RandomReminder
//
//  Created by Luca Napoli on 14/2/2025.
//

import SwiftUI

struct StepperTextField: View {
    @Binding var value: Int
    var range: ClosedRange<Int> = Int.min...Int.max
    var spacing: CGFloat = -5

    var body: some View {
        HStack(spacing: spacing) {
            TextField("", value: $value, formatter: ReminderConstants.numberFormatter)
                .onChange(of: value) { oldValue, newValue in
                    value = constrainValue(newValue, orElse: oldValue)
                }
            Stepper(
                "",
                onIncrement: {
                    value = constrainValue(value + 1, orElse: value)
                },
                onDecrement: {
                    value = constrainValue(value - 1, orElse: value)
                }
            )
        }
    }

    private func constrainValue(_ value: Int, orElse defaultValue: Int) -> Int {
        range.contains(value) ? value : defaultValue
    }
}

struct StepperTextField_Previews: PreviewProvider {
    @State private static var value = 1

    static var previews: some View {
        StepperTextField(value: $value)
            .padding()
            .frame(width: 100)
    }
}
