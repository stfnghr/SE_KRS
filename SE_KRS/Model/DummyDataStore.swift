// File: Services/DummyDataStore.swift
import Foundation
import Combine

class DummyDataStore {
    static let shared = DummyDataStore()
    var userBalances: [String: Double] = [:]
    var orders: [Order] = []
    var transactions: [TransactionModels] = []

    // Counter untuk ID unik (untuk dummy)
    var orderIdCounter: Int = 1
    var transactionIdCounter: Int = 1

    // --- Helper ID Generators ---
    func generateOrderId() -> String {
        let newId = String(format: "ORD%03d", orderIdCounter)
        orderIdCounter += 1
        return newId
    }

    func generateTransactionId() -> String {
        let newId = String(format: "TRX%03d", transactionIdCounter)
        transactionIdCounter += 1
        return newId
    }
}
