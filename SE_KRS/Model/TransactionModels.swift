import Foundation

enum TransactionType: String, Codable, Hashable {
    case orderPayment = "Order Payment"
    case topUp = "Top-Up"
}

enum TransactionStatus: String, Codable, Hashable {
    case success = "Success"
    case failed = "Failed"
}

// PENYESUAIAN: Struct TransactionModels dilengkapi
struct TransactionModels: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    var type: TransactionType
    // PENYESUAIAN: Dibuat menjadi opsional
    var orderId: String?
    var amount: Double
    var status: TransactionStatus
    // PENYESUAIAN: Properti baru ditambahkan
    var timestamp: Date
    var description: String
    var paymentMethodDetail: String?
}

