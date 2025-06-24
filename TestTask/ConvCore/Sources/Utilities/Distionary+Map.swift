//
//  Distionary+Map.swift
//  ConvCore
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//

import Foundation

extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) throws -> T) rethrows -> [T: Value] {
        var newDict: [T: Value] = [:]
        for (key, value) in self {
            let newKey = try transform(key)
            newDict[newKey] = value
        }
        return newDict
    }
}
