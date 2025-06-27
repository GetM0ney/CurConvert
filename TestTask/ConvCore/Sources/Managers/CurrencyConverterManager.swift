//
//  CurrencyConverterManager.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//


public protocol ICurrencyConverterManager {
    func convert(
        amount: Double,
        from base: Currency,
        to target: Currency
    ) async throws -> CurrencyConversionResult
}

public struct CurrencyConversionResult {
    public init(rate: Double, convertedAmount: Double) {
        self.rate = rate
        self.convertedAmount = convertedAmount
    }
    
   public let rate: Double
   public let convertedAmount: Double
}

public final class CurrencyConverterManagerImpl: ICurrencyConverterManager {
    private let rateService: CurrencyRateService
    private let referenceBase: Currency = .usd

    public init(rateService: CurrencyRateService) {
        self.rateService = rateService
    }

    public func convert(
        amount: Double,
        from source: Currency,
        to target: Currency
    ) async throws -> CurrencyConversionResult {
        guard source != target else {
            return CurrencyConversionResult(rate: 1.0, convertedAmount: amount)
        }

        let rates = try await rateService.getRates(for: referenceBase)
        
        var rateToSource: Double?
        if let rate = rates[source] {
            rateToSource = rate
        } else {
            if source == .usd {
                rateToSource = 1.0
            } else {
                throw NetworkError.invalidResponse
            }
        }

        guard let sourceRate = rateToSource else {
            throw NetworkError.invalidResponse
        }
        
        var rateToTarget: Double?
        if let rate = rates[target] {
            rateToTarget = rate
        } else {
            if target == .usd {
                rateToTarget = 1.0
            } else {
                throw NetworkError.invalidResponse
            }
        }

        guard let targetRate = rateToTarget else {
            throw NetworkError.invalidResponse
        }
        let conversionRate = targetRate / sourceRate
        let convertedAmount = amount * conversionRate

        return CurrencyConversionResult(rate: conversionRate, convertedAmount: convertedAmount)
    }
}
