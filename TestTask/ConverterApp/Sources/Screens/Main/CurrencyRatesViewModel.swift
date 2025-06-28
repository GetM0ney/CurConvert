//
//  CurrencyRatesViewModel.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//


import Foundation
import Combine
import ConvCore

@MainActor
final class CurrencyRatesViewModel: ObservableObject {
    @Published var baseCurrency: Currency {
        didSet {
            saveBaseCurrency()
            convertedResult = nil
            Task { await loadRates() }
            
        }
    }
    
    @Published var targetCurrency: Currency {
        didSet {
            saveTargerCurrency()
            convertedResult = nil
        }
    }
    @Published var amountString: String = ""
    @Published var convertedResult: Double?
    @Published var rates: [Currency: Double] = [:]
    @Published var errorMessage: ErrorMessage?
    
    @Published var isShownHistory: Bool = false
    
    private let currencyRateService: CurrencyRateService
    private let converter: ICurrencyConverterManager
    private let historyManager: any IConversionHistoryManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        baseCurrency: Currency,
        currencyRateService: CurrencyRateService,
        converter: ICurrencyConverterManager,
        historyManager: any IConversionHistoryManager
    ) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = Currency.allCases.first(where: { $0 != baseCurrency }) ?? baseCurrency
        
        self.currencyRateService = currencyRateService
        self.historyManager = historyManager
        self.converter = converter
        
        setupTimer()
        setCurrentCurrencies()
        Task { await loadRates() }
    }
    
    func convert() {
        guard let amount = Double(amountString) else {
            errorMessage = ErrorMessage(message: "Некорректная сумма")
            return
        }
        
        Task {
            do {
                let result = try await converter.convert(amount: amount, from: baseCurrency, to: targetCurrency)
                await MainActor.run {
                    self.convertedResult = result.convertedAmount
                    self.errorMessage = nil
                    
                    let historyItem = ConversionHistoryItem(
                        date: Date(),
                        from: baseCurrency,
                        to: targetCurrency,
                        amount: amount,
                        result: result.convertedAmount,
                        rate: result.rate
                    )
                    
                    self.historyManager.add(historyItem)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = ErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
    func reloadManually() async {
        await loadRates()
    }
    
    func startAutoRefresh() {
        currencyRateService.startAutoRefresh()
    }
    
    private func saveBaseCurrency() {
        UserDefaults.standard.set(baseCurrency.rawValue, forKey: "baseCurrency")
    }
    
    private func saveTargerCurrency() {
        UserDefaults.standard.set(targetCurrency.rawValue, forKey: "targetCurrency")
    }
    
    private func setCurrentCurrencies() {
        if let baseCurrency = UserDefaults.standard.string(forKey: "baseCurrency") {
            self.baseCurrency = Currency(rawValue: baseCurrency) ?? .usd
        }
        
        if let targetCurrency = UserDefaults.standard.string(forKey: "targetCurrency") {
            self.targetCurrency = Currency(rawValue: targetCurrency) ?? .eur
        }
    }
    private func setupTimer() {
        Timer
            .publish(every: 30 * 60, on: .main, in: .common)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                Task { await self.loadRates() }
            }
            .store(in: &cancellables)
    }
    
    private func loadRates() async {
        do {
            let fetchedRates = try await currencyRateService.getRates(for: baseCurrency)
            self.rates = fetchedRates
            self.errorMessage = nil
        } catch {
            self.errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }
}
