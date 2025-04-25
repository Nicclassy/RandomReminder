//
//  ColourString.swift
//  RandomReminder
//
//  Created by Luca Napoli on 30/12/2024.
//

import Foundation

let backgroundDefault = true

func hex(_ hex: String) -> ColourString {
    let value = Int(hex.trimmingPrefix("#"), radix: 16)!
    let r = (value >> 16) & 0xFF
    let g = (value >> 8) & 0xFF
    let b = value & 0xFF
    return rgb(r, g, b)
}

func rgb(_ r: Int, _ g: Int, _ b: Int, background: Bool = backgroundDefault) -> ColourString {
    ColourString(code: String(format: "\u{001B}[%d;2;%d;%d;%dm", background ? 48 : 38, r, g, b))
}

func xterm256(_ id: Int, background: Bool = backgroundDefault) -> ColourString {
    ColourString(code: String(format: "\u{001B}[%d;5;%dm", background ? 48 : 38, id))
}

func ansi(_ ansi: Int, background: Bool = backgroundDefault) -> ColourString {
    ColourString(code: String(format: "\u{001B}[%dm", background ? ansi + 10 : ansi))
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
