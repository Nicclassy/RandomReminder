//
//  Array+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/2/2025.
//

import Foundation

extension Array {
    func chunked(ofCount: Int) -> [[Element]] {
        stride(from: 0, to: count, by: ofCount).map { chunkStart in
            let chunkEnd = Swift.min(chunkStart + ofCount, count)
            return Self(self[chunkStart..<chunkEnd])
        }
    }

    func listing(separator: String = ", ") -> String where Element == String {
        guard !isEmpty else { return "" }
        guard count > 1 else { return first! }
        let separatedElements = dropLast()
        return "\(separatedElements.joined(separator: separator)) and \(last!)"
    }
}
