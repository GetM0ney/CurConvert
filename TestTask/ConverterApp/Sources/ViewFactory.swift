//
//  ViewFactory.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 25.06.2025.
//

import Swinject
import ConvCore
import SwiftUI


final class ViewFactory {
    private let container: Resolver

    init(container: Resolver) {
        self.container = container
    }

    func makeCurrencyRatesView(baseCurrency: Currency) -> some View {
        CurrencyRatesView(baseCurrency: .usd, container: container)
            .ignoresSafeArea()
    }
}
