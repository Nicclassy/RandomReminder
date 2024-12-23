//
//  Constants.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation

// An implementation of C#'s null-coalescing
infix operator ??=: AssignmentPrecedence

func ??=<T>(a: inout T?, b: T) {
    a = a ?? b
}
