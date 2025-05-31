import Foundation

enum TransactionType: String, Codable, Hashable {
    case orderPayment = "Order Payment"
    case topUp = "Top-Up"
}

enum TransactionStatus: String, Codable, Hashable {
    case success = "Success"
    case failed = "Failed"
}

struct Transaction: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    var type: TransactionType
    var orderId: String?
    var amount: Double
    var status: TransactionStatus
    var timestamp: Date
    var description: String
    var paymentMethodDetail: String?
}
