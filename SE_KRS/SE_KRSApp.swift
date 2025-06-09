// File: SE_KRSApp.swift
import SwiftUI

@main
struct SE_KRSApp: App {
    // BENAR: Menggunakan @StateObject untuk membuat instance pertama kali.
    @StateObject var userSession: UserSession
    @StateObject var cartViewModel: CartViewModel

    init() {
        let session = UserSession()
        _userSession = StateObject(wrappedValue: session)
        _cartViewModel = StateObject(wrappedValue: CartViewModel(userSession: session))
    }

    var body: some Scene {
        WindowGroup {
            if userSession.isLoggedIn {
                MainView()
                    // BENAR: Meneruskan object yang sama ke seluruh environment.
                    .environmentObject(userSession)
                    .environmentObject(cartViewModel)
            } else {
                LandingView()
                    .environmentObject(userSession)
                    .environmentObject(cartViewModel)
            }
        }
    }
}
