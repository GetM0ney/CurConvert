//
//  AppDIContainer.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//


import Swinject
import ConvCore
import ConvComponents

final class AppDIContainer {
    static let shared = AppDIContainer()

    let container: Container = {
        let container = Container()
        _ = Assembler([CoreAssembly()], container: container)
        return container
    }()
}
