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
        itemAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.75)
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.75),
      
        ]

        itemAppearance.selected.iconColor = UIColor.white
        itemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance 
        appearance.compactInlineLayoutAppearance = itemAppearance 
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
               
                }
              
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
