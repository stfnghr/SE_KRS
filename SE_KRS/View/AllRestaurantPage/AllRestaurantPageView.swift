// File: View/AllRestaurantsView.swift
import SwiftUI

struct AllRestaurantsView: View {
    // Menerima data semua restoran
    let restaurants: [RestaurantModel]

    // Mengatur tampilan grid dengan 2 kolom
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(restaurants) { restaurant in
                    // --- REVISI PEMANGGILAN ---
                    // Panggil init yang benar dan hapus .whiteCard
                    FoodCardView(restaurant: restaurant)
                }
            }
            .padding()
        }
        .navigationTitle("Semua Restoran")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255).ignoresSafeArea())
    }
}

#Preview {
    // Contoh data untuk preview
    let dummyRestaurants: [RestaurantModel] = [
        RestaurantModel(id: UUID(), name: "Nasi Goreng Jaya", address: "Jl. Raya Kemenangan No. 1", rating: 4.8, image: "nasi-goreng-44", menuItems: [], isOpen: true),
        RestaurantModel(id: UUID(), name: "Bubur Ayam Nikmat", address: "Jl. Pagi Hari No. 2", rating: 4.5, image: "bubur-ayam-sby", menuItems: [], isOpen: true),
        RestaurantModel(id: UUID(), name: "Kopi Senja Menyala", address: "Jl. Sore No. 3", rating: 4.9, image: "koopi", menuItems: [], isOpen: true)
    ]
    
    return NavigationView {
        AllRestaurantsView(restaurants: dummyRestaurants)
    }
}
