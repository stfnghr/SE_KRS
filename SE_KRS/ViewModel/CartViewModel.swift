import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var activeCart: [OrderModels] = []
    @Published var currentCartSubtotalItems: Double = 0.0
    @Published var shippingFee: Double = 5000
    @Published var discount: Double = 0
    
    var currentCartTotalPayable: Double {
        currentCartSubtotalItems + shippingFee - discount
    }

    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var orderProcessedSuccessfully: Bool = false
    @Published var processedOrderId: String?
    @Published var alertTitle: String = "Info"
    @Published var paymentProcessing: Bool = false

    var userSession: UserSession
    private let dataStore = DummyDataStore.shared

    init(userSession: UserSession) {
        self.userSession = userSession
    }
    
    func addItemToCart(menuItem: MenuModel, restaurant: RestaurantModel? = nil, quantity: Int = 1) {
        guard menuItem.isAvailable else {
            alertTitle = "Stok Habis"
            alertMessage = "Maaf, \(menuItem.name) stoknya habis."
            showAlert = true
            return
        }
        guard quantity > 0 else { return }

        if let index = activeCart.firstIndex(where: { $0.itemId == menuItem.id.uuidString }) {
            activeCart[index].quantity += quantity
        } else {
            let orderModel = OrderModels(
                itemId: menuItem.id.uuidString,
                itemName: menuItem.name,
                quantity: quantity,
                pricePerItem: menuItem.price
            )
            activeCart.append(orderModel)
        }
        calculateCartSubtotal()
    }

    func removeItemFromCart(itemId: String) {
        activeCart.removeAll(where: { $0.id == itemId })
        calculateCartSubtotal()
    }
    
    func updateItemQuantityInCart(itemId: String, newQuantity: Int) {
        if let index = activeCart.firstIndex(where: { $0.id == itemId }) {
            if newQuantity > 0 {
                activeCart[index].quantity = newQuantity
            } else {
                activeCart.remove(at: index)
            }
        }
        calculateCartSubtotal()
    }

    func clearCart() {
        activeCart.removeAll()
        calculateCartSubtotal()
    }

    private func calculateCartSubtotal() {
        currentCartSubtotalItems = activeCart.reduce(0) { $0 + $1.subtotal }
    }
    
    func checkout(paymentMethod: PaymentType, restaurantForOrder: RestaurantModel? = nil) {
        guard let userId = userSession.currentUserId, let loggedInUser = userSession.loggedInUser else {
            alertTitle = "Error"; alertMessage = "Anda harus login untuk melakukan checkout."; showAlert = true; return
        }
        guard !activeCart.isEmpty else {
            alertTitle = "Error"; alertMessage = "Keranjang Anda kosong."; showAlert = true; return
        }

        paymentProcessing = true
        orderProcessedSuccessfully = false
        processedOrderId = nil

        let newOrderId = dataStore.generateOrderId()
        let orderSubtotal = currentCartSubtotalItems
        let finalAmountToPay = orderSubtotal + shippingFee - discount

        var order = Order(
            id: newOrderId,
            userId: userId,
            items: activeCart,
            totalAmount: finalAmountToPay,
            subTotalItems: orderSubtotal,
            shippingFee: self.shippingFee,
            discount: self.discount,
            status: .pendingPayment,
            timestampCreated: Date(),
            timestampUpdated: Date(),
            paymentMethodUsed: paymentMethod,
            restaurantId: restaurantForOrder?.id.uuidString,
            restaurantName: restaurantForOrder?.name,
            deliveryAddress: loggedInUser.email
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            var paymentSucceeded = false
            var transactionStatus: TransactionStatus = .failed
            var transactionDescription = ""
            var paymentMethodDetailDesc = ""

            switch paymentMethod {
            case .balance:
                paymentMethodDetailDesc = "Saldo Aplikasi"
                let currentBalance = self.dataStore.userBalances[userId] ?? 0.0
                if currentBalance >= finalAmountToPay {
                    self.dataStore.userBalances[userId] = currentBalance - finalAmountToPay
                    paymentSucceeded = true
                    transactionStatus = .success
                    transactionDescription = "Pembayaran pesanan #\(newOrderId) dengan saldo berhasil."
                } else {
                    transactionStatus = .failed
                    transactionDescription = "Pembayaran gagal. Saldo tidak mencukupi. Butuh Rp\(String(format: "%.0f", finalAmountToPay - currentBalance)) lagi."
                }
                
            case .creditCard:
                paymentMethodDetailDesc = "Kartu Kredit (Dummy)"
                if finalAmountToPay <= 50000 {
                    paymentSucceeded = true
                    transactionStatus = .success
                    transactionDescription = "Pembayaran pesanan #\(newOrderId) dengan kartu kredit (dummy) berhasil."
                } else {
                    paymentSucceeded = false
                    transactionStatus = .failed
                    transactionDescription = "Pembayaran pesanan #\(newOrderId) dengan kartu kredit (dummy) ditolak (Limit Terlampaui)."
                }
            }

            if paymentSucceeded {
                order.status = .processing
                order.timestampUpdated = Date()
                self.alertTitle = "Pesanan Diproses!"
                self.alertMessage = "Pembayaran berhasil! Pesanan Anda #\(newOrderId) sedang diproses."
                self.clearCart()
            } else {
                order.status = .paymentFailed
                order.timestampUpdated = Date()
                self.alertTitle = "Pembayaran Gagal"
                self.alertMessage = transactionDescription
            }
            
            if let orderIndex = self.dataStore.orders.firstIndex(where: { $0.id == newOrderId }) {
                 self.dataStore.orders[orderIndex] = order
            } else {
                 self.dataStore.orders.append(order)
            }

            let paymentTransaction = TransactionModels(
                id: self.dataStore.generateTransactionId(),
                userId: userId,
                type: .orderPayment,
                orderId: newOrderId,
                amount: paymentSucceeded ? -finalAmountToPay : 0,
                status: transactionStatus,
                timestamp: Date(),
                description: transactionDescription,
                paymentMethodDetail: paymentMethodDetailDesc
            )
            self.dataStore.transactions.append(paymentTransaction)

            self.processedOrderId = paymentSucceeded ? newOrderId : nil
            self.orderProcessedSuccessfully = paymentSucceeded
            self.paymentProcessing = false
            self.showAlert = true
        }
    }
}

