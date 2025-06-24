//
//  Collection+safe.swift
//  MuveComponents
//
//  Created by Uladzimir Lishanenka on 29.05.2025.
//

import Foundation

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
