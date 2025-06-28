//
//  ConversionHistoryManager.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//

import Foundation
import Combine

public protocol IConversionHistoryManager: ObservableObject {
    var historyPublisher: AnyPublisher<[ConversionHistoryItem], Never> { get }
    var history: [ConversionHistoryItem] { get set }
    func add(_ item: ConversionHistoryItem)
}

public final class ConversionHistoryManager: IConversionHistoryManager {
    @Published public var history: [ConversionHistoryItem] = []

    public var historyPublisher: AnyPublisher<[ConversionHistoryItem], Never> {
        $history.eraseToAnyPublisher()
    }
    public func add(_ item: ConversionHistoryItem) {
        history.insert(item, at: 0)
    }
}
