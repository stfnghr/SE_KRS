//
//  RestaurantViewModel.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 29/05/25.
//

import Foundation

class RestaurantViewModel {
    @Published var restaurants = [RestaurantModel]()
    
    init() {
        restaurants = [
            RestaurantModel(
                name: "Nasi Goreng 44",
                address: "Jl. Raya Bandung Barat No. 44",
                rating: 4.5,
                image: "nasi-goreng-44",
                menu: MenuModel(
                    name: "Nasi Goreng Spesial",
                    price: 20000,
                    description: "Nasi goreng spesial, ditambah telor mata sapi",
                    category: "Nasi",
                    image: "nasi-goreng")
            ),
            RestaurantModel(
                name: "Bubur Ayam Surabaya",
                address: "Jl. Arjuno No. 12",
                rating: 4.3,
                image: "bubur-ayam-sby",
                menu: MenuModel(
                    name: "Bubur Ayam Original",
                    price: 12000,
                    description: "Bubur + ayam + cakwe + kulit pangsit + bawang goreng + kecap asin",
                    category: "Bubur",
                    image: "bubur-ayam-ori")
            ),
            RestaurantModel(
                name: "Koo-pi",
                address: "Ruko Mutiara No.8",
                rating: 4.9,
                image: "koopi",
                menu: MenuModel(
                    name: "Kopi Gula Aren",
                    price: 18000,
                    description: "Kopi, susu, dan gula aren.",
                    category: "Kopi",
                    image: "kopi-gula-aren")
            ),
        ]
    }
    
    // ...
}
