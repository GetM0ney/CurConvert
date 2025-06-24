//
//  CurrencyView.swift
//  Converter
//
//  Created by Uladzimir Lishanenka on 20.06.2025.
//

import SwiftUI

struct CurrencyView: View {
    @Binding var currencyName: String
    @Binding var currencyShortName: String
    @Binding var currencyValue: Double
    
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 8, content: {
            Text(currencyName)
                .font(Font.system(size: 15, weight: .semibold, design: .default))
                .foregroundStyle(Color.white)
            Text(currencyShortName)
                .font(Font.system(size: 15, weight: .semibold, design: .default))
                .foregroundStyle(Color.gray)
            Text(String(format: "%.2f", currencyValue))
                .font(Font.system(size: 15, weight: .semibold, design: .default))
                .foregroundStyle(Color.white)
            
        })
        .padding()
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    CurrencyView(currencyName: .constant("US Dollar"), currencyShortName: .constant("USD"), currencyValue: .constant(0), onTap: {
        
    })
}
