import Foundation
import Combine
import SwiftUI

class UserSession: ObservableObject {
    @Published var currentUserId: String?
    @Published var loggedInUser: UserModel?
    @Published var showStatusNotification: Bool = false
    @Published var statusNotificationMessage: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let dataStore = DummyDataStore.shared

    func loginUser(user: UserModel, message: String) {
        self.loggedInUser = user
        self.currentUserId = user.id.uuidString

        if DummyDataStore.shared.userBalances[user.id.uuidString] == nil {
            DummyDataStore.shared.userBalances[user.id.uuidString] = user.balance
        }
        
        self.statusNotificationMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                self.showStatusNotification = true
            }
        }
        
        print("UserSession: \(user.name) logged in, ID: \(user.id.uuidString)")
    }

    func logoutUser() {
        self.loggedInUser = nil
        self.currentUserId = nil
        
        self.showStatusNotification = false
        self.statusNotificationMessage = ""
        
        print("User logged out.")
    }

    var isLoggedIn: Bool {
        return currentUserId != nil
    }
}
