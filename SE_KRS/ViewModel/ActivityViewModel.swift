import Foundation
import Combine

class ActivityViewModel: ObservableObject {
    @Published var onProcessOrders: [Order] = []
    @Published var historicalOrders: [Order] = []
    @Published var isLoading: Bool = false

    private var userSession: UserSession
    private let dataStore = DummyDataStore.shared
    private var cancellables = Set<AnyCancellable>()

    init(userSession: UserSession) {
        self.userSession = userSession
        
        userSession.$currentUserId
            .sink { [weak self] _ in
                self?.fetchAllUserOrders()
            }
            .store(in: &cancellables)
    }

    func fetchAllUserOrders() {
        guard let userId = userSession.currentUserId else {
            // Jika logout, kosongkan daftar
            onProcessOrders = []
            historicalOrders = []
            return
        }
        isLoading = true
        
        let allUserOrders = self.dataStore.orders.filter { $0.userId == userId }
                                        .sorted { $0.timestampCreated > $1.timestampCreated }
        
        onProcessOrders = allUserOrders.filter {
            [.paid, .processing].contains($0.status)
        }
        
        historicalOrders = allUserOrders.filter {
            [.outForDelivery, .delivered, .cancelled, .paymentFailed].contains($0.status)
        }
        
        isLoading = false
    }
    
    func updateOrderStatus(orderId: String, newStatus: OrderStatus) {
        guard let userId = userSession.currentUserId else { return }
        
        if let orderIndex = dataStore.orders.firstIndex(where: { $0.id == orderId && $0.userId == userId }) {
            dataStore.orders[orderIndex].status = newStatus
            dataStore.orders[orderIndex].timestampUpdated = Date()
            print("Order \(orderId) status updated to \(newStatus.rawValue) in DataStore.")
            fetchAllUserOrders()
        }
    }
    
    func getOrderById(_ orderId: String) -> Order? {
        guard let userId = userSession.currentUserId else { return nil }
        return dataStore.orders.first(where: { $0.id == orderId && $0.userId == userId })
    }
}
