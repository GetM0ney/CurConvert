//
//  CurrencyRatesResponse.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//


struct CurrencyRatesResponse: Codable {
    let data: [String: Double]

}

extension CurrencyRatesResponse {
    var asTyped: [Currency: Double] {
        let pairs: [(Currency, Double)] = data.compactMap { key, value in
            guard let currency = Currency(rawValue: key) else { return nil }
            return (currency, value)
        }

        return Dictionary(uniqueKeysWithValues: pairs)
    }
}
