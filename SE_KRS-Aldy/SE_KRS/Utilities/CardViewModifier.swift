// File: Utilities/ViewModifiers.swift

import SwiftUI

// Mendefinisikan modifier untuk style kartu yang konsisten
struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
}

// Membuat extension agar mudah digunakan
extension View {
    func asCard() -> some View {
        self.modifier(CardViewModifier())
    }
}
