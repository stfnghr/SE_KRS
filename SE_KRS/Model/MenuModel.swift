//
//  MenuModel.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 29/05/25.
//

import Foundation

struct MenuModel: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var description: String
    var category: String
    var image: String
    var stock: Int = 10 // Default stok 10
    var isAvailable: Bool { // Computed property
        return stock > 0
    }
}
