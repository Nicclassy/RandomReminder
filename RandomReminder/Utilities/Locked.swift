//
//  Locked.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/4/2025.
//

import Foundation

@propertyWrapper
final class Locked<Value> {
    private var value: Value
    private let lock = NSLock()
    
    var wrappedValue: Value {
        get { lock.withLock { value } }
        set (value) { lock.withLock { self.value = value } }
    }
    
    init(wrappedValue value: Value) {
        self.value = value
    }
}
