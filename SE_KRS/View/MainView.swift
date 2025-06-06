import SwiftUI

struct MainView: View {
    var body: some View {
        AnimatedNavbar()
    }
}

#Preview {
    MainView()
        .environmentObject(UserSession())
        .environmentObject(CartViewModel(userSession: UserSession()))
}
