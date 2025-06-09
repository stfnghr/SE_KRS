//
//  RestaurantModel.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 29/05/25.
//

import Foundation

// File: Model/RestaurantModel.swift
struct RestaurantModel: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var rating: Double
    var image: String
    // PENYESUAIAN: Tipe data diubah menjadi array [MenuModel]
    var menuItems: [MenuModel] = []
    // PENYESUAIAN: Properti baru ditambahkan
    var isOpen: Bool = true
    var operationalHours: String = "09:00 - 22:00"
}
