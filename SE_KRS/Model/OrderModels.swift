// File: SE_KRS/Model/OrderModels.swift (REVISED)

import Foundation

enum OrderStatus: String, Codable, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case pendingPayment = "Pending Payment"
    case paid = "Paid"
    case paymentFailed = "Payment Failed"
    case processing = "Processing"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
}

enum PaymentType: String, Codable, Hashable, CaseIterable, Identifiable {
    case balance = "Saldo Aplikasi"
    case creditCard = "Kartu Kredit (Dummy)"
    
    var id: String { self.rawValue }
}

struct OrderModels: Identifiable, Codable, Hashable {
    var itemId: String
    var itemName: String
    var quantity: Int
    var pricePerItem: Double

    var subtotal: Double {
        pricePerItem * Double(quantity)
    }


    var id: String { itemId }
}


struct Order: Identifiable, Codable, Hashable {
    let id: String
    let userId: String
    var items: [OrderModels]
    var totalAmount: Double
    var subTotalItems: Double
    var shippingFee: Double = 10000
    var discount: Double = 0
    var status: OrderStatus
    var timestampCreated: Date
    var timestampUpdated: Date
    var paymentMethodUsed: PaymentType?
    var restaurantId: String?
    var restaurantName: String?
    var deliveryAddress: String?
    var courierInfo: String?
    
    func calculateFinalAmount() -> Double {
        return subTotalItems + shippingFee - discount
    }
}
