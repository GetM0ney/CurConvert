//
//  ConversionHistoryViewModel.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//


import Combine
import Foundation
import ConvCore

@MainActor
final class ConversionHistoryViewModel: ObservableObject {
    @Published private(set) var history: [ConversionHistoryItem] = []
    
    private let historyManager: any IConversionHistoryManager
    private var cancellables = Set<AnyCancellable>()
    
    
    init(historyManager: any IConversionHistoryManager) {
        self.historyManager = historyManager
        
        historyManager.historyPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.history = items
            }
            .store(in: &cancellables)
    }
}
