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
            convertedResult = nil
            Task { await loadRates() }
        }
    }

    @Published var targetCurrency: Currency {
        didSet {
            convertedResult = nil
        }
    }
    @Published var amountString: String = ""
    @Published var convertedResult: Double?
    @Published var rates: [Currency: Double] = [:]
    @Published var errorMessage: ErrorMessage?

    private let currencyRateService: CurrencyRateService
    private let converter: ICurrencyConverterManager
    private var cancellables = Set<AnyCancellable>()

    init(
        baseCurrency: Currency,
        currencyRateService: CurrencyRateService,
        converter: ICurrencyConverterManager
    ) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = Currency.allCases.first(where: { $0 != baseCurrency }) ?? baseCurrency
        self.currencyRateService = currencyRateService
        self.converter = converter

        setupTimer()
        Task { await loadRates() }
    }

    func convert() {
        Task {
            guard let amount = Double(amountString) else {
                errorMessage = ErrorMessage(message: "Некорректная сумма")
                return
            }

            do {
                let result = try await converter.convert(
                    amount: amount,
                    from: baseCurrency,
                    to: targetCurrency
                )
                self.convertedResult = result.convertedAmount
            } catch {
                errorMessage = ErrorMessage(message: error.localizedDescription)
            }
        }
    }

    func reloadManually() async {
        await loadRates()
    }

    func startAutoRefresh() {
        currencyRateService.startAutoRefresh()
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
