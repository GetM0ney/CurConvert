//
//  CoreAssembly.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//


import Swinject

public final class CoreAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(NetworkService.self) { _ in
            NetworkServiceImp()
        }.inObjectScope(.container)

        container.register(CurrencyRateService.self) { r in
            CurrencyRateServiceImpl(networkService: r.resolve(NetworkService.self)!)
        }.inObjectScope(.container)

        container.register(ICurrencyConverterManager.self) { r in
            CurrencyConverterManagerImpl(rateService: r.resolve(CurrencyRateService.self)!)
        }.inObjectScope(.container)
        
//        container.register((any IConversionHistoryManager).self) { _ in
//            ConversionHistoryManager()
//        }.inObjectScope(.container)
        
        container.register((any IConversionHistoryManager).self) { _ in
            PersistentConversionHistoryManager()
        }.inObjectScope(.container)
    }
}
