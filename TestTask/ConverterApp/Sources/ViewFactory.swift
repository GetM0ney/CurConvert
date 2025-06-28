//
//  ViewFactory.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 25.06.2025.
//

import Swinject
import ConvCore
import SwiftUI


final class ViewFactoryWrapper: ObservableObject {
    let factory: ViewFactory
    init(factory: ViewFactory) {
        self.factory = factory
    }
}

final class ViewFactory {
    private let container: Resolver

    init(container: Resolver) {
        self.container = container
    }

    func makeCurrencyRatesView(baseCurrency: Currency) -> some View {
        CurrencyRatesView(baseCurrency: .usd, container: container)
            .ignoresSafeArea()
    }
    
    @MainActor
    func makeConversionHistoryView() -> some View {
        let manager = container.resolve((any IConversionHistoryManager).self)!
        let viewModel = ConversionHistoryViewModel(historyManager: manager)
        return ConversionHistoryView(viewModel: viewModel)
    }
}
