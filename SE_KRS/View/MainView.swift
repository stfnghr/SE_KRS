// File: View/MainView.swift
import SwiftUI

struct MainView: View {
    // Inject UserSession untuk mengakses status notifikasi
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        ZStack {
            // Konten utama aplikasi (Navbar dan Halaman)
            AnimatedNavbar()

            // --- REVISI: Menampilkan Notifikasi di Atas Segalanya ---
            if userSession.showStatusNotification {
                StatusNotificationView(
                    isShowing: $userSession.showStatusNotification,
                    message: userSession.statusNotificationMessage,
                    iconName: "checkmark.circle.fill"
                )
            }
            // --------------------------------------------------------
        }
    }
}

#Preview {
    MainView()
        .environmentObject(UserSession())
        .environmentObject(CartViewModel(userSession: UserSession()))
}
