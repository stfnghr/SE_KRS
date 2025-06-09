// File: SE_KRSApp.swift
import SwiftUI

@main
struct SE_KRSApp: App {
    @StateObject var userSession: UserSession
    @StateObject var cartViewModel: CartViewModel

    init() {
        let session = UserSession()
        _userSession = StateObject(wrappedValue: session)
        _cartViewModel = StateObject(wrappedValue: CartViewModel(userSession: session))
    }

    var body: some Scene {
        WindowGroup {
            // Logika baru: Jika login, tampilkan MainView. Jika tidak, tampilkan LandingView.
            if userSession.isLoggedIn {
                MainView()
                    .environmentObject(userSession)
                    .environmentObject(cartViewModel)
            } else {
                LandingView() // << REVISI DI SINI
                    .environmentObject(userSession)
                    // CartViewModel bisa tetap di-inject jika diperlukan di alur login/signup
                    .environmentObject(cartViewModel)
            }
        }
    }
}
