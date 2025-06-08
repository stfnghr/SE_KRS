import Foundation

class RestaurantViewModel: ObservableObject {
    @Published var restaurants = [RestaurantModel]()
    
    init() {
        let nasiGoreng44Menu = [
            MenuModel(name: "Nasi Goreng Spesial", price: 20000, description: "Nasi goreng spesial, ditambah telor mata sapi", category: "Nasi", image: "nasi-goreng", stock: 15),
            MenuModel(name: "Mie Goreng 44", price: 18000, description: "Mie goreng dengan bumbu khas", category: "Mie", image: "foods", stock: 10),
            MenuModel(name: "Es Teh Manis", price: 5000, description: "Teh manis segar", category: "Minuman", image: "kopi-gula-aren", stock: 0)
        ]
        
        let buburAyamSurabayaMenu = [
            MenuModel(name: "Bubur Ayam Original", price: 12000, description: "Bubur + ayam + cakwe + kulit pangsit + bawang goreng + kecap asin", category: "Bubur", image: "bubur-ayam-ori", stock: 20),
            MenuModel(name: "Bubur Ayam Spesial Telur Asin", price: 18000, description: "Bubur original ditambah telur asin", category: "Bubur", image: "bubur-ayam-ori", stock: 8)
        ]
        
        let koopiMenu = [
            MenuModel(name: "Kopi Gula Aren", price: 18000, description: "Kopi, susu, dan gula aren.", category: "Kopi", image: "kopi-gula-aren", stock: 25),
            MenuModel(name: "Americano", price: 15000, description: "Kopi hitam tanpa gula.", category: "Kopi", image: "koopi", stock: 30),
            MenuModel(name: "Roti Bakar Cokelat", price: 10000, description: "Roti bakar dengan meses.", category: "Roti", image: "foods", stock: 0)
        ]

        restaurants = [
            RestaurantModel(
                id: UUID(), name: "Nasi Goreng 44",
                address: "Jl. Raya Bandung Barat No. 44",
                rating: 4.5,
                image: "nasi-goreng-44",
                menuItems: nasiGoreng44Menu,
                isOpen: true
            ),
            RestaurantModel(
                id: UUID(), name: "Bubur Ayam Surabaya",
                address: "Jl. Arjuno No. 12",
                rating: 4.3,
                image: "bubur-ayam-sby",
                menuItems: buburAyamSurabayaMenu,
                isOpen: false,
                operationalHours: "SEDANG TUTUP"
            ),
            RestaurantModel(
                id: UUID(), name: "Koo-pi",
                address: "Ruko Mutiara No.8",
                rating: 4.9,
                image: "koopi",
                menuItems: koopiMenu,
                isOpen: true
            ),
        ]
    }
}


