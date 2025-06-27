//
//  CurrencyRateService.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//

import Foundation
import UIKit

public protocol CurrencyRateService {
    func getRates(for base: Currency) async throws -> [Currency: Double]
    func startAutoRefresh()
    func stopAutoRefresh()
}

public final class CurrencyRateServiceImpl: CurrencyRateService {
    private let networkService: NetworkService
    private let storage = CurrencyRateStorage()

    private let freshnessInterval: TimeInterval = 30 * 60
    private let lastUpdatedKeyPrefix = "last_updated_"

    private var timer: Timer?

    public init(networkService: NetworkService) {
        self.networkService = networkService

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        stopAutoRefresh()
    }

    // MARK: - Public API

    public func getRates(for base: Currency) async throws -> [Currency: Double] {
        if !isDataFresh(for: base) {
            try await refreshRates(for: base)
        }

        if let cached = storage.get(for: base) {
            return cached
        }

        try await refreshRates(for: base)

        guard let fallback = storage.get(for: base) else {
            throw NetworkError.invalidResponse
        }

        return fallback
    }

    public func startAutoRefresh() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: freshnessInterval, repeats: true) { [weak self] _ in
            Task {
                await self?.refreshIfNeeded()
            }
        }
    }

    public func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Refresh Logic

    private func refreshRates(for base: Currency) async throws {
        let endpoint = APIEndpoint.latest(
            currencies: Currency.allCases.filter { $0 != base },
            base: base
        )

        let response: CurrencyRatesResponse = try await networkService.fetch(endpoint)
        storage.save(response.asTyped, for: base)
        saveLastUpdated(Date(), for: base)
        print("✅ Refreshed rates for base: \(base.rawValue)")
    }

    @MainActor
    private func refreshIfNeeded() async {
        for base in Currency.allCases {
            if !isDataFresh(for: base) {
                try? await refreshRates(for: base)
            }
        }
    }

    // MARK: - Freshness Tracking

    private func isDataFresh(for base: Currency) -> Bool {
        guard let lastUpdated = getLastUpdated(for: base) else {
            return false
        }
        return Date().timeIntervalSince(lastUpdated) < freshnessInterval
    }

    private func saveLastUpdated(_ date: Date, for base: Currency) {
        UserDefaults.standard.set(date, forKey: lastUpdatedKey(for: base))
    }

    private func getLastUpdated(for base: Currency) -> Date? {
        UserDefaults.standard.object(forKey: lastUpdatedKey(for: base)) as? Date
    }

    private func lastUpdatedKey(for base: Currency) -> String {
        lastUpdatedKeyPrefix + base.rawValue
    }

    // MARK: - Foreground Hook

    @objc private func handleAppForeground() {
        Task {
            await refreshIfNeeded()
        }
    }
}
