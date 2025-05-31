//
//  RestaurantModel.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 29/05/25.
//

import Foundation

struct RestaurantModel: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var rating: Double
    var image: String
    // var menu: MenuModel // Ganti ini
    var menuItems: [MenuModel] = [] // Menjadi array MenuModel
    var isOpen: Bool = true // Defaultnya restoran buka
    var operationalHours: String = "09:00 - 22:00" // Contoh jam operasional
}
