//
//  JSONDecoder+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/1/2025.
//

import Foundation

extension JSONDecoder {
    static func applicationDefault() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
