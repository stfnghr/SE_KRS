import SwiftUI

@main
struct SE_KRSApp: App {
    @StateObject var userSession: UserSession
    @StateObject var cartViewModel: CartViewModel // Dibuat di sini

    init() {
        let session = UserSession() // Satu instance UserSession
        _userSession = StateObject(wrappedValue: session)
        // CartViewModel menggunakan instance UserSession yang sama
        _cartViewModel = StateObject(wrappedValue: CartViewModel(userSession: session))
    }

    var body: some Scene {
        WindowGroup {
            if userSession.isLoggedIn {
                MainView()
                    .environmentObject(userSession)
                    .environmentObject(cartViewModel) // <<< INJECT CartViewModel INI
            } else {
                LoginSignupView()
                    .environmentObject(userSession)
                    .environmentObject(cartViewModel) // Inject juga jika diperlukan
            }
        }
    }
}
