//
//  Utilities.swift
//  RandomReminder
//
//  Created by Luca Napoli on 1/8/2025.
//

import Foundation

func removeFunctionNameParentheses(_ functionName: String) -> String {
    String(describing: functionName.split(separator: "(").first!)
}

func shouldntBeCalled(function: String = #function) -> Never {
    fatalError("The function \(removeFunctionNameParentheses(function)) should not be called")
}
