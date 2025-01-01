//
//  DebugPrint.swift
//  RandomReminder
//
//  Created by Luca Napoli on 29/12/2024.
//

import Foundation

let debuggingEnabled: Bool = true

let debugPrintColours = DebugPrinterColours(
    file: hex("CFBAF0"),
    function: hex("B9FBC0"),
    line: hex("EFC9C1"),
    separator: hex("98F5E1"),
    string: hex("FFCFD2")
)

let debugErrorColours = DebugPrinterColours(
    file: hex("FFA5AB"),
    function: hex("721036"),
    line: hex("450920"),
    separator: hex("DA627D"),
    string: hex("A53860")
)

func debug(_ args: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    printer(args, colours: debugPrintColours, file: file, function: function, line: line)
}

func err(_ args: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    printer(args, colours: debugErrorColours, file: file, function: function, line: line)
}

fileprivate func printer(_ args: [Any], colours: DebugPrinterColours, file: String, function: String, line: Int) {
    guard debuggingEnabled else { return }
    let stackTraceInfo = DebugPrintHelper.formatStackTrackInfo(
        file: file,
        function: function,
        line: line,
        colours: colours
    )
    let formattedArgs = DebugPrintHelper.formatArgs(args: args, colours: colours)
    print("\(stackTraceInfo) \(formattedArgs)")
}

struct DebugPrinterColours {
    var file: ColourString
    var function: ColourString
    var line: ColourString
    var separator: ColourString
    var string: ColourString
}

fileprivate final class DebugPrintHelper {
    private static let fileNameLength: Int = 28
    private static let functionNameLength: Int = 25
    private static let lineNumberLength: Int = 4
    
    private static let separator: String = "|"
    private static let startSeparator: String = "["
    private static let endSeparator: String = "]"
    private static let argsSeparator: String = ":"
    
    static func formatStackTrackInfo(file: String, function: String, line: Int, colours: DebugPrinterColours) -> String {
        let fileFormatted = pad(formatFile(file), toLength: fileNameLength)
        let functionFormatted = pad(formatFunction(function), toLength: functionNameLength)
        let lineFormatted = pad(formatLine(line), toLength: lineNumberLength)
        return "\(colours.separator(startSeparator)) \(colours.function(functionFormatted))"
            + "\(colours.separator(separator)) \(colours.file(fileFormatted))"
            + "\(colours.separator(separator)) \(colours.line(lineFormatted))"
            + "\(colours.separator(endSeparator))\(colours.separator(argsSeparator))"
    }
    
    static func formatArgs(args: Any..., colours: DebugPrinterColours) -> String {
        colours.string(args.map { String(describing: $0) }.joined(separator: " "))
    }
    
    private static func formatFile(_ file: String) -> String {
        String(describing: file
            .split(separator: "/")
            .last!
            .split(separator: ".")
            .first!
        )
    }
    
    private static func formatFunction(_ function: String) -> String {
        String(describing: function.split(separator: "(").first!)
    }
    
    private static func formatLine(_ line: Int) -> String {
        String(describing: line)
    }
    
    private static func pad(_ value: String, toLength: Int) -> String {
        value.padding(toLength: toLength, withPad: " ", startingAt: 0)
    }
}