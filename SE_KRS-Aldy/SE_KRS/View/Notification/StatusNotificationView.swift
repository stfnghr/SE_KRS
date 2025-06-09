// File: View/StatusNotificationView.swift
import SwiftUI

struct StatusNotificationView: View {
    // Binding untuk mengontrol visibilitas dari parent view
    @Binding var isShowing: Bool
    let message: String
    let iconName: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Text(message)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(30)
        .background(Color.black.opacity(0.7))
        .cornerRadius(20)
        .shadow(radius: 10)
        .transition(.scale.combined(with: .opacity))
        .onAppear {
            // Setelah 2 detik, notifikasi akan hilang
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isShowing = false
                }
            }
        }
    }
}

#Preview {
    // Contoh cara menggunakan notifikasi
    ZStack {
        Color.blue.ignoresSafeArea()
        StatusNotificationView(
            isShowing: .constant(true),
            message: "Login Berhasil!",
            iconName: "checkmark.circle.fill"
        )
    }
}
