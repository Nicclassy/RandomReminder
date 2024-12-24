//
//  Constants.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation

// An implementation of C#'s null-coalescing assignment operator
infix operator ??=: AssignmentPrecedence

func ??=<T>(lhs: inout T?, rhs: T) {
    lhs = lhs ?? rhs
}
