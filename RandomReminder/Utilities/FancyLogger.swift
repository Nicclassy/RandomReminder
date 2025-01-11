//
//  FancyLogger.swift
//  RandomReminder
//
//  Created by Luca Napoli on 29/12/2024.
//

import Foundation

let loggingEnabled: Bool = true

let infoColours = FancyLogger.Colours(
    file: hex("CFBAF0"),
    function: hex("B9FBC0"),
    line: hex("EFC9C1"),
    separator: hex("98F5E1"),
    string: hex("FFCFD2")
)

let warnColours = FancyLogger.Colours(
    file: hex("FFA5AB"),
    function: hex("721036"),
    line: hex("450920"),
    separator: hex("DA627D"),
    string: hex("A53860")
)

final class FancyLogger {
    static let fileNameLength: Int = 28
    static let functionNameLength: Int = 25
    static let lineNumberLength: Int = 4
    
    static let separator: String = "|"
    static let startSeparator: String = "["
    static let endSeparator: String = "]"
    static let argsSeparator: String = ":"
    static let printArgsSeparator: String = " "
    
    struct Colours {
        let file: ColourString
        let function: ColourString
        let line: ColourString
        let separator: ColourString
        let string: ColourString
    }
    
    static func info(_ args: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        FancyLoggerHelper.printer(args, colours: infoColours, file: file, function: function, line: line)
    }

    static func warn(_ args: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        FancyLoggerHelper.printer(args, colours: warnColours, file: file, function: function, line: line)
    }
}

fileprivate final class FancyLoggerHelper {
    static func printer(_ args: [Any], colours: FancyLogger.Colours, file: String, function: String, line: Int) {
        guard loggingEnabled else { return }
        let stackTraceInfo = formatStackTrackInfo(
            file: file,
            function: function,
            line: line,
            colours: colours
        )
        let formattedArgs = formatArgs(args: args, colours: colours)
        print("\(stackTraceInfo) \(formattedArgs)")
    }

    private static func formatStackTrackInfo(file: String, function: String, line: Int, colours: FancyLogger.Colours) -> String {
        let fileFormatted = pad(formatFile(file), toLength: FancyLogger.fileNameLength)
        let functionFormatted = pad(formatFunction(function), toLength: FancyLogger.functionNameLength)
        let lineFormatted = pad(formatLine(line), toLength: FancyLogger.lineNumberLength)
        return "\(colours.separator(FancyLogger.startSeparator)) \(colours.function(functionFormatted))"
            + "\(colours.separator(FancyLogger.separator)) \(colours.file(fileFormatted))"
            + "\(colours.separator(FancyLogger.separator)) \(colours.line(lineFormatted))"
            + "\(colours.separator(FancyLogger.endSeparator))\(colours.separator(FancyLogger.argsSeparator))"
    }
    
    private static func formatArgs(args: Any..., colours: FancyLogger.Colours) -> String {
        colours.string(args.map { String(describing: $0) }.joined(separator: FancyLogger.printArgsSeparator))
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
