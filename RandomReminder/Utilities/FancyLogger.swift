//
//  FancyLogger.swift
//  RandomReminder
//
//  Created by Luca Napoli on 29/12/2024.
//

import Foundation
import os.log

let loggingEnabled: Bool = true
let useOsLog: Bool = false

let infoColours = FancyLogger.Colours(
    file: hex("CFBAF0"),
    function: hex("CDECDE"),
    line: hex("EFC9C1"),
    separator: hex("98F5E1"),
    string: hex("FFCFD2")
)

let errorColours = FancyLogger.Colours(
    file: hex("FFA5AB"),
    function: hex("721036"),
    line: hex("450920"),
    separator: hex("DA627D"),
    string: hex("A53860")
)

private enum LogLevel {
    case info
    case warn
    case error
}

private enum FancyLoggerHelper {
    private static let log = Logger()

    // swiftlint:disable:next function_parameter_count
    static func printer(
        _ args: [Any],
        colours: FancyLogger.Colours,
        file: String,
        function: String,
        line: UInt,
        level: LogLevel
    ) {
        guard loggingEnabled else { return }
        let stackTraceInfo = formatStackTraceInfo(
            file: file,
            function: function,
            line: line,
            colours: colours
        )
        let formattedArgs = formatArgs(args: args, colours: colours)
        let message = "\(stackTraceInfo) \(formattedArgs)"

        guard useOsLog else {
            print(message)
            return
        }

        switch level {
        case .info:
            log.info("\(message)")
        case .warn:
            log.warning("\(message)")
        case .error:
            log.critical("\(message)")
        }
    }

    private static func formatStackTraceInfo(
        file: String,
        function: String,
        line: UInt,
        colours: FancyLogger.Colours
    ) -> String {
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
        String(describing: file.split(separator: "/").last!.split(separator: ".").first!)
    }

    private static func formatFunction(_ function: String) -> String {
        removeFunctionNameParentheses(function)
    }

    private static func formatLine(_ line: UInt) -> String {
        String(describing: line)
    }

    private static func pad(_ value: String, toLength: Int) -> String {
        value.padding(toLength: toLength, withPad: " ", startingAt: 0)
    }
}

enum FancyLogger {
    struct Colours {
        let file: ColourString
        let function: ColourString
        let line: ColourString
        let separator: ColourString
        let string: ColourString

        init(
            file: ColourString = .blank,
            function: ColourString = .blank,
            line: ColourString = .blank,
            separator: ColourString = .blank,
            string: ColourString = .blank
        ) {
            self.file = file
            self.function = function
            self.line = line
            self.separator = separator
            self.string = string
        }
    }

    static let fileNameLength: Int = 28
    static let functionNameLength: Int = 25
    static let lineNumberLength: Int = 4

    static let separator: String = "|"
    static let startSeparator: String = "["
    static let endSeparator: String = "]"
    static let argsSeparator: String = ":"
    static let printArgsSeparator: String = " "

    static func info(_ args: Any..., file: String = #file, function: String = #function, line: UInt = #line) {
        FancyLoggerHelper.printer(
            args,
            colours: infoColours,
            file: file,
            function: function,
            line: line,
            level: .info
        )
    }

    static func warn(_ args: Any..., file: String = #file, function: String = #function, line: UInt = #line) {
        FancyLoggerHelper.printer(
            args,
            colours: errorColours,
            file: file,
            function: function,
            line: line,
            level: .warn
        )
    }

    static func error(_ args: Any..., file: String = #file, function: String = #function, line: UInt = #line) {
        FancyLoggerHelper.printer(
            args,
            colours: errorColours,
            file: file,
            function: function,
            line: line,
            level: .error
        )
    }
}
