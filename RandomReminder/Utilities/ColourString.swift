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
    // Approximate each colour to its closest xterm256-colour code
    let xtermRed = r / 51
    let xtermGreen = g / 51
    let xtermBlue = b / 51
    let xtermColour = 16 + 36 * xtermRed + 6 * xtermGreen + xtermBlue
    return xterm256(xtermColour)
}

func ansi(_ ansi: Int) -> ColourString {
    ColourString(code: String(format: "\u{001B}[%dm", ansi))
}

fileprivate func xterm256(_ xtermColour: Int) -> ColourString {
    // Because xterm256-colour only supports 255 colours, not all colours
    // cannot be accurately represented. Colours are therefore approximated in the
    // above rgb function.
    ColourString(code: String(format: "\u{001B}[38;5;%dm", xtermColour))
}

fileprivate func termEnvValueExists() -> Bool {
    ProcessInfo.processInfo.environment["TERM"] != nil
}

class ColourString: CustomStringConvertible {
    static let colourStrings: Bool = true
    
    let code: String
    
    init(code: String) {
        self.code = code
    }
    
    var description: String {
        self.code
    }
    
    func callAsFunction(_ string: any CustomStringConvertible) -> String {
        // Credit: https://github.com/onevcat/Rainbow/blob/master/Sources/OutputTarget.swift
        if Self.colourStrings && termEnvValueExists() && isatty(fileno(stdout)) != 0 {
            "\(self)\(string)\(Self.reset)"
        } else {
            String(describing: string)
        }
        
    }
    
    static let reset = ansi(0)
    
    static let red = ansi(31)
    static let blue = ansi(34)
    static let black = ansi(30)
    static let green = ansi(32)
    static let yellow = ansi(33)
    static let magenta = ansi(35)
    static let cyan = ansi(36)
    static let white = ansi(97)
}
