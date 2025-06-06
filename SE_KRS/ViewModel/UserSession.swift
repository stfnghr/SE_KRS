// File: ViewModel/UserSession.swift
import Foundation
import Combine

class UserSession: ObservableObject {
    @Published var currentUserId: String?
    @Published var loggedInUser: UserModel?

    private var cancellables = Set<AnyCancellable>()
    private let dataStore = DummyDataStore.shared

    // Di dalam UserSession.swift
    func loginUser(user: UserModel) {
        self.loggedInUser = user
        self.currentUserId = user.id.uuidString // Pastikan ini di-set

        // Inisialisasi atau update saldo pengguna di DummyDataStore
        // Perhatikan: user.balance adalah saldo awal dari UserModel saat signup/login dummy
        if DummyDataStore.shared.userBalances[user.id.uuidString] == nil {
            DummyDataStore.shared.userBalances[user.id.uuidString] = user.balance
        } else {
            // Jika Anda ingin saldo dari UserModel meng-override yang ada di DataStore setiap login:
            // DummyDataStore.shared.userBalances[user.id.uuidString] = user.balance
        }
        print("UserSession: \(user.name) logged in, ID: \(user.id.uuidString), Initial Balance for session: \(user.balance)")
    }

    func logoutUser() {
        self.loggedInUser = nil
        self.currentUserId = nil
        // Anda bisa membersihkan keranjang di CartViewModel di sini jika perlu
        print("User logged out.")
    }

    var isLoggedIn: Bool {
        return currentUserId != nil
    }
}
