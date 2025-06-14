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
    var menuItems: [MenuModel] = []
    var isOpen: Bool = true
    var operationalHours: String = "09:00 - 22:00"
}
