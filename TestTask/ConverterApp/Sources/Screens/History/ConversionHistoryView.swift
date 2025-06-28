//
//  ConversionHistoryView.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//

import SwiftUI
import ConvCore

struct ConversionHistoryView: View {
    @StateObject var viewModel: ConversionHistoryViewModel

    var body: some View {
        List(viewModel.history) { item in
            VStack(alignment: .leading) {
                Text("\(item.amount, specifier: "%.2f") \(item.from.rawValue) → \(item.to.rawValue)")
                    .font(.headline)
                Text("= \(item.result, specifier: "%.2f") \(item.to.rawValue)")
                    .font(.subheadline)
                Text(item.date.formatted())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("История переводов")
    }
}
