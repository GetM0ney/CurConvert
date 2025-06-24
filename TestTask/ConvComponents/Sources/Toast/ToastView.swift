//
//  ToastView.swift
//  MuveComponents
//
//  Created by Uladzimir Lishanenka on 26.01.2025.
//

import SwiftUI

public struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
    
    public init(style: ToastStyle, message: String, duration: Double = 3, width: Double = .infinity) {
        self.style = style
        self.message = message
        self.duration = duration
        self.width = width
    }
}

public enum ToastStyle {
    case info
}

public extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .info: return .black
        }
    }
    
    internal var iconFileName: ImageResource {
        switch self {
        case .info: return .check
        }
    }
}

public struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    public init(style: ToastStyle, message: String, width: CGFloat = CGFloat.infinity, onCancelTapped: @escaping () -> Void) {
        self.style = style
        self.message = message
        self.width = width
        self.onCancelTapped = onCancelTapped
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(message)
                .foregroundColor(Color.mvBtnText)
                .typographyStyle(.heading15Regular)
            Spacer(minLength: 10)
            Image(style.iconFileName)
                .renderingMode(.template)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(minWidth: 0, maxWidth: width)
        .background(Color.mvAlertBg)
        .cornerRadius(8)
    }
}

public struct ToastModifier: ViewModifier {
    
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .padding(.horizontal, 20)
                        .offset(y: 70)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder public func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                ) {
                    dismissToast()
                }
                .padding(.bottom, 90)
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

public extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
