// File: View/AnimatedNavbar.swift
import SwiftUI

struct AnimatedNavbar: View {
    @EnvironmentObject var userSession: UserSession

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.red

        let itemAppearance = UITabBarItemAppearance()
        
        // Warna untuk status NORMAL (tidak aktif)
        itemAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.75) // Ikon putih sedikit lebih jelas
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.75),
            // --- MUNGKIN COBA TAMBAHKAN FONT SIZE UNTUK TEKS ---
            // NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10) // Sesuaikan ukuran jika perlu
        ]

        // Warna untuk status SELECTED (aktif)
        itemAppearance.selected.iconColor = UIColor.white
        itemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            // NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10) // Sesuaikan ukuran jika perlu
        ]
        
        // --- MENCORBA MENYESUAIKAN POSISI TEKS (MUNGKIN BERDAMPAK KE RUANG IKON) ---
        // itemAppearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2) // Geser teks sedikit ke bawah
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance // Jarang digunakan tapi baik untuk konsistensi
        appearance.compactInlineLayoutAppearance = itemAppearance // Jarang digunakan tapi baik untuk konsistensi
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                    // --- COBA GUNAKAN FONT UNTUK IKON ---
                    // Menggunakan .font() di sini mungkin tidak banyak efek pada ikon sistem,
                    // tapi bisa dicoba. Ukuran ikon sistem lebih diatur oleh `pointSize` gambar itu sendiri.
                }
                // .font(.system(size: 20)) // Menerapkan font ke seluruh tab item, bisa dicoba

            CartView()
                .tabItem {
                    Label("Keranjang", systemImage: "cart.fill")
                }

            ActivityView(userSession: userSession)
                .tabItem {
                    Label("Aktivitas", systemImage: "list.clipboard.fill")
                }

            ProfileView(userSession: userSession)
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .tint(.white)
    }
}

#Preview {
    // ... (kode preview tidak berubah) ...
    let previewUserSession = UserSession()
    let previewCartViewModel = CartViewModel(userSession: previewUserSession)

    return AnimatedNavbar()
        .environmentObject(previewUserSession)
        .environmentObject(previewCartViewModel)
}
