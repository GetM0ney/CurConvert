//
//  CurrencyRateStorage.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//

import Foundation

final class CurrencyRateStorage {
    private var cache: [Currency: [Currency: Double]] = [:]

    func save(_ rates: [Currency: Double], for base: Currency) {
        cache[base] = rates
    }

    func get(for base: Currency) -> [Currency: Double]? {
        cache[base]
    }
}

