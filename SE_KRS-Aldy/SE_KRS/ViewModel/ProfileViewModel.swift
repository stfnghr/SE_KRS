import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userBalance: Double = 0.0
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    private var userSession: UserSession
    private let dataStore = DummyDataStore.shared
    private var cancellables = Set<AnyCancellable>()

    init(userSession: UserSession) {
        self.userSession = userSession
        
        userSession.$loggedInUser
            .compactMap { $0 }
            .sink { [weak self] userModel in
                self?.fetchBalance(for: userModel.id.uuidString)
            }
            .store(in: &cancellables)
        
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
        self.userBalance = newBalance

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
