//
//  CurrencyRates.swift
//  Converter
//
//  Created by Uladzimir Lishanenka on 20.06.2025.
//


import Foundation

import Foundation

enum Currency: String, CaseIterable {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case chf = "CHF"
    case cny = "CNY"
}

struct CurrencyRates: Codable {
    private var rates: [Currency: Double]
    
    subscript(currency: Currency) -> Double? {
        return rates[currency]
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempRates: [Currency: Double] = [:]
        
        for key in container.allKeys {
            if let currency = Currency(rawValue: key.stringValue) {
                let value = try container.decode(Double.self, forKey: key)
                tempRates[currency] = value
            }
        }
        
        self.rates = tempRates
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for (currency, value) in rates {
            let key = DynamicCodingKeys(stringValue: currency.rawValue)
            try container.encode(value, forKey: key)
        }
    }
}


struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int? { return nil }

    init?(intValue: Int) { return nil }
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
}
