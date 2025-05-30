// File: Services/DummyDataStore.swift
import Foundation
import Combine

class DummyDataStore {
    static let shared = DummyDataStore() // Singleton instance

    // Data yang sebelumnya ada di KRSStoreService, sekarang di sini.
    var userBalances: [String: Double] = [:] // [UserID: Balance]
    var orders: [Order] = [] // Pastikan struct Order sudah didefinisikan
    var transactions: [Transaction] = [] // Pastikan struct Transaction sudah didefinisikan

    // Counter untuk ID unik (untuk dummy)
    var orderIdCounter: Int = 1
    var transactionIdCounter: Int = 1

    private init() {
        // Inisialisasi data awal jika perlu
        // Contoh:
        // setupInitialDummyUsers()
    }
    
//    private func setupInitialDummyUsers() {
//        // Contoh jika Anda ingin membuat beberapa pengguna dummy saat aplikasi dimulai
//        // Ini bisa lebih baik dilakukan di UserSession atau saat proses login/signup
//        let initialUser1 = UserModel(name: "Alice Wonderland", phone: "08111", email: "alice@example.com", password: "password123", balance: 200000)
//        let initialUser2 = UserModel(name: "Bob The Builder", phone: "08222", email: "bob@example.com", password: "password456", balance: 150000)
//
//        userBalances[initialUser1.id.uuidString] = initialUser1.balance
//        userBalances[initialUser2.id.uuidString] = initialUser2.balance
//
//        // Jika Anda punya array users global (tidak disarankan, lebih baik dikelola UserSession)
//        // users.append(initialUser1)
//        // users.append(initialUser2)
//        print("DummyDataStore: Initial dummy users balances set up.")
//    }


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
