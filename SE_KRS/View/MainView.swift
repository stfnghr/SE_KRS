import SwiftUI

struct MainView: View {
    var body: some View {
        AnimatedNavbar()
        // userSession dan cartViewModel akan diteruskan dari SE_KRSApp
    }
}
// Preview untuk MainView juga perlu environment objects
#Preview {
    MainView()
        .environmentObject(UserSession())
        .environmentObject(CartViewModel(userSession: UserSession()))
}
