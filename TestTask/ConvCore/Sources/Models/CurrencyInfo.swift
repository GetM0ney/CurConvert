//
//  CurrencyInfo.swift
//  Converter
//
//  Created by Uladzimir Lishanenka on 20.06.2025.
//


import Foundation

struct CurrencyInfo: Codable {
    let symbol: String
    let name: String
    let symbol_native: String
    let decimal_digits: Int
    let rounding: Int
    let code: String
    let name_plural: String
    let type: String
}

struct CurrencyDetailsResponse: Codable {
    let data: [String: CurrencyInfo]
}
