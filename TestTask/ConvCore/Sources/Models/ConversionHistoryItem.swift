//
//  ConversionHistoryItem.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//

import Foundation

public struct ConversionHistoryItem: Identifiable {
    
    public init(date: Date, from: Currency, to: Currency, amount: Double, result: Double, rate: Double) {
        self.date = date
        self.from = from
        self.to = to
        self.amount = amount
        self.result = result
        self.rate = rate
    }
    
    public let id = UUID()
    public let date: Date
    public let from: Currency
    public let to: Currency
    public let amount: Double
    public let result: Double
    public let rate: Double
}
