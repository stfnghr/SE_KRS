// File: Utilities/Color+Hex.swift (CONTOH NAMA FILE BARU)
import SwiftUI

//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default: (a, r, g, b) = (1, 1, 1, 0) // Default ke transparan jika format salah
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}

// File: Utilities/Color.swift
extension Color {
    // Definisikan warna utama aplikasi Anda di sini
    static let primaryRed = Color.red
    static let secondaryText = Color.gray
    static let lightBackground = Color(red: 245/255, green: 245/255, blue: 245/255)
}
