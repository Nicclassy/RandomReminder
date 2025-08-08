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

func filenameFromPath(_ file: String, includeExtension: Bool = false) -> String {
    let filename = file.split(separator: "/").last!
    return includeExtension ? String(describing: filename) : String(describing: filename.split(separator: ".").first!)
}

func shouldntBeCalled(function: String = #function, file: String = #file, line: Int = #line) -> Never {
    let caller = removeFunctionNameParentheses(function)
    let filename = filenameFromPath(file, includeExtension: true)
    printCallStackFunctionNames()
    fatalError("The function '\(caller)' in '\(filename)' (line \(line)) should not be called")
}
