//
//  CurrencyRatesView.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 24.06.2025.
//

import SwiftUI
import ConvCore
import Swinject

struct ErrorMessage: Identifiable {
    let id = UUID()
    let message: String
}

struct CurrencyRatesView: View {
    @StateObject private var viewModel: CurrencyRatesViewModel

    init(baseCurrency: Currency, container: Resolver) {
        let service = container.resolve(CurrencyRateService.self)!
        let converter = container.resolve(ICurrencyConverterManager.self)!
        _viewModel = StateObject(wrappedValue: CurrencyRatesViewModel(
            baseCurrency: baseCurrency,
            currencyRateService: service,
            converter: converter
        ))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Базовая валюта")
                        .font(.headline)

                    Picker("Из", selection: $viewModel.baseCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text("Целевая валюта")
                        .font(.headline)

                    Picker("В", selection: $viewModel.targetCurrency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text("Сумма")
                        .font(.headline)

                    TextField("Введите сумму", text: $viewModel.amountString)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Конвертировать") {
                        viewModel.convert()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.amountString.isEmpty)

                   
                    if let result = viewModel.convertedResult {
                        Text("Результат: \(result) \(viewModel.targetCurrency.rawValue)")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(maxHeight: .infinity)
            }
            
            .navigationTitle("Конвертер валют")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "clock")
                    }
                }
            }
            .refreshable {
                await viewModel.reloadManually()
            }
            .onAppear {
                viewModel.startAutoRefresh()
            }
            .alert(item: $viewModel.errorMessage) { error in
                Alert(
                    title: Text("Ошибка"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
