//
//  ColourString.swift
//  RandomReminder
//
//  Created by Luca Napoli on 30/12/2024.
//

import Foundation

func hex(_ hex: String) -> ColourString {
    let value = Int(hex.trimmingPrefix("#"), radix: 16)!
    let r = (value >> 16) & 0xFF
    let g = (value >> 8) & 0xFF
    let b = value & 0xFF
    return rgb(r, g, b)
}

func rgb(_ r: Int, _ g: Int, _ b: Int) -> ColourString {
    ColourString(code: String(format: "\033[38;2;%d;%d;%dm", r, g, b))
}

func xterm256(_ id: Int) -> ColourString {
    ColourString(code: String(format: "\033[38;5;%dm", id))
}

func ansi(_ ansi: Int) -> ColourString {
    ColourString(code: String(format: "\033[%dm", ansi))
}

private func termEnvValueExists() -> Bool {
    ProcessInfo.processInfo.environment["TERM"] != nil
}

struct ColourString: CustomStringConvertible {
    static let colourStrings: Bool = false

    static let red = ansi(31)
    static let blue = ansi(34)
    static let black = ansi(30)
    static let green = ansi(32)
    static let yellow = ansi(33)
    static let magenta = ansi(35)
    static let cyan = ansi(36)
    static let white = ansi(97)
    static let reset = ansi(0)

    static let blank = Self(code: String())

    let code: String

    var description: String {
        code
    }

    func callAsFunction(_ string: any CustomStringConvertible) -> String {
        // Credit: https://github.com/onevcat/Rainbow/blob/master/Sources/OutputTarget.swift
        if Self.colourStrings && termEnvValueExists() && isatty(fileno(stdout)) != 0 {
            "\(self)\(string)\(Self.reset)"
        } else {
            String(describing: string)
        }
    }
}
