//
//  SwapButton.swift
//  Converter
//
//  Created by Uladzimir Lishanenka on 20.06.2025.
//
import SwiftUI

struct SwapButton: View {
    let action: () -> Void
    @State private var isFlipped = false

    internal init(action: @escaping () -> Void) {
        self.action = action
    }
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.4)) {
                isFlipped.toggle()
            }
            action()
        }) {
            Image(systemName: "arrow.trianglehead.swap")
                .rotationEffect(.degrees(isFlipped ? 180 : 0))
                .animation(.easeInOut, value: isFlipped)
        }
        .buttonStyle(NoHighlightButtonStyle())
    }
}

struct NoHighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .blue : .blue) // Цвет при нажатии
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1) // отключаем системное затемнение
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
