// File: ViewModel/ProfileViewModel.swift
import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userBalance: Double = 0.0
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    // Simpan UserSession sebagai @ObservedObject atau teruskan sebagai parameter
    // jika ProfileViewModel dibuat oleh View yang sudah memiliki UserSession.
    // Untuk @StateObject di View, kita akan meneruskannya di init.
    private var userSession: UserSession
    private let dataStore = DummyDataStore.shared
    private var cancellables = Set<AnyCancellable>()

    init(userSession: UserSession) {
        self.userSession = userSession
        
        // Amati perubahan pada currentUserId atau loggedInUser dari userSession
        userSession.$loggedInUser // Mengamati loggedInUser lebih baik karena kita butuh balance awal
            .compactMap { $0 } // Hanya proses jika user tidak nil
            .sink { [weak self] userModel in
                self?.fetchBalance(for: userModel.id.uuidString)
            }
            .store(in: &cancellables)
        
        // Ambil saldo awal jika pengguna sudah login saat ViewModel dibuat
        if let initialUserId = userSession.currentUserId {
             fetchBalance(for: initialUserId)
        }
    }

    func fetchBalance(for userId: String? = nil) {
        let targetUserId = userId ?? userSession.currentUserId
        guard let finalUserId = targetUserId else {
            userBalance = 0.0
            return
        }
        userBalance = dataStore.userBalances[finalUserId] ?? 0.0
    }

    func topUpBalance(amount: Double) {
        guard let userId = userSession.currentUserId else {
            alertMessage = "User not logged in."
            showAlert = true
            return
        }
        guard amount > 0 else {
            alertMessage = "Top-up amount must be positive."
            showAlert = true
            return
        }

        let currentBalanceInStore = dataStore.userBalances[userId] ?? 0.0
        let newBalance = currentBalanceInStore + amount
        dataStore.userBalances[userId] = newBalance
        self.userBalance = newBalance // Update published property

        let transactionId = dataStore.generateTransactionId()
        let transaction = TransactionModels(
            id: transactionId,
            userId: userId,
            type: .topUp,
            orderId: nil,
            amount: amount,
            status: .success,
            timestamp: Date(),
            description: "Balance top-up of \(String(format: "%.2f", amount))"
        )
        dataStore.transactions.append(transaction)
        
        alertMessage = "Top-up successful. New balance: \(String(format: "%.2f", newBalance))"
        showAlert = true
    }
}
