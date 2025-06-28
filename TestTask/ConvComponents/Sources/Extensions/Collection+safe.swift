//
//  Collection+safe.swift
//  MuveComponents
//
//  Created by Uladzimir Lishanenka on 29.05.2025.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
