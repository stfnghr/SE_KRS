// File: View/AllFoodsView.swift
import SwiftUI

struct AllFoodsView: View {
    // Menerima data semua menu populer
    let popularMenus: [MenuModel]
    let dummyRestaurant: RestaurantModel

    // Mengatur tampilan grid dengan 3 kolom
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(popularMenus) { menu_item in
                    FoodCardView(menuItem: menu_item, restaurant: dummyRestaurant)
                }
            }
            .padding()
        }
        .navigationTitle("Semua Pilihan Makanan")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255).ignoresSafeArea())
    }
}

#Preview {
    let popularMenus: [MenuModel] = [
        MenuModel(name: "Nasi Goreng Populer", price: 23000, description: "Populer dan enak", category: "Nasi", image: "nasi-goreng", stock: 5),
        MenuModel(name: "Ayam Geprek Viral", price: 20000, description: "Pedasnya nampol", category: "Ayam", image: "foods", stock: 0),
        MenuModel(name: "Es Kopi Kekinian", price: 22000, description: "Wajib coba", category: "Kopi", image: "kopi-gula-aren", stock: 10)
    ]
    let dummyRestaurantPlaceholder = RestaurantModel(name: "Popular Spot", address: "Various", rating: 0, image: "foods", menuItems: [])

    return NavigationView {
        AllFoodsView(popularMenus: popularMenus, dummyRestaurant: dummyRestaurantPlaceholder)
    }
}
