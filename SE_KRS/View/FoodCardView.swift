// File: View/FoodCardView.swift (REVISED)
import SwiftUI



// --- View Utama ---
struct FoodCardView: View {
    // Properti ini akan menentukan data apa yang akan ditampilkan
    let restaurant: RestaurantModel?
    let menuItem: MenuModel?
    
    // State untuk alert
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    // Inisialisasi untuk kartu Restoran
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        self.menuItem = nil
    }

    // Inisialisasi untuk kartu Menu Item (Populer)
    init(menuItem: MenuModel, restaurant: RestaurantModel) {
        self.restaurant = restaurant // Tetap dibutuhkan untuk navigasi
        self.menuItem = menuItem
    }
    
    var body: some View {
        Group {
            if let restaurant = restaurant, menuItem == nil {
                // --- Tampilan untuk Kartu Restoran (White Card) ---
                NavigationLink(destination: MenuView(restaurant: restaurant)) {
                    RestaurantCard(restaurant: restaurant)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    if !restaurant.isOpen {
                        self.alertTitle = "Restoran Tutup"
                        self.alertMessage = "Maaf, \(restaurant.name) sedang tutup (${restaurant.operationalHours})."
                        self.showingAlert = true
                    }
                }
            } else if let menuItem = menuItem, let restaurant = restaurant {
                // --- Tampilan untuk Kartu Makanan Populer (Red Card) ---
                 NavigationLink(destination: DetailMenuView(menuItem: menuItem)) {
                    PopularMenuItemCard(menuItem: menuItem)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    if !menuItem.isAvailable {
                        self.alertTitle = "Stok Habis"
                        self.alertMessage = "Maaf, \(menuItem.name) stoknya sedang habis."
                        self.showingAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


// MARK: - Subview untuk Kartu Restoran
struct RestaurantCard: View {
    let restaurant: RestaurantModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // --- REVISI: Gambar dengan Overlay Status ---
            ZStack {
                Image(restaurant.image.isEmpty ? "foods" : restaurant.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 110)
                    .clipped()

                if !restaurant.isOpen {
                    Color.black.opacity(0.4)
                    Text("TUTUP")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            .cornerRadius(15, corners: [.topLeft, .topRight])
            
            // --- REVISI: Konten Teks yang Lebih Rapi ---
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.system(size: 15, weight: .bold)) // Ukuran konsisten
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text(String(format: "%.1f", restaurant.rating))
                    Text("• est. 20 min") // Contoh info tambahan
                }
                .font(.caption) // Ukuran konsisten
                .foregroundColor(.secondary) // Warna abu-abu untuk info sekunder
            }
            .padding(10)
            .frame(width: 175, alignment: .leading)
            .background(Color.white)
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        }
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
        .opacity(restaurant.isOpen ? 1.0 : 0.7)
    }
}


// MARK: - Subview untuk Kartu Makanan Populer
struct PopularMenuItemCard: View {
    let menuItem: MenuModel

    var body: some View {
        ZStack(alignment: .bottomLeading) { // Align semua konten ke bawah kiri
            // 1. Gambar sebagai background
            Image(menuItem.image.isEmpty ? "foods" : menuItem.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 200) // Ukuran kartu dibuat lebih besar

            // 2. Gradien gelap untuk keterbacaan teks
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )

            // 3. Konten Teks (Nama & Harga)
            VStack(alignment: .leading, spacing: 2) {
                Text(menuItem.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text("Rp\(String(format: "%.0f", menuItem.price))")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(12)

            // 4. Overlay jika stok habis
            if !menuItem.isAvailable {
                // Overlay gelap di seluruh kartu
                Color.black.opacity(0.5)
                
                // Teks status di tengah
                Text("STOK HABIS")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
            }
        }
        .frame(width: 150, height: 200)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 4)
        .opacity(menuItem.isAvailable ? 1.0 : 0.7)
    }
}


// MARK: - Preview
#Preview("FoodCardView") {
    // Data dummy untuk semua state
    let availableMenu = MenuModel(name: "Nasi Goreng Spesial", price: 20000, description: "Enak", category: "Nasi", image: "nasi-goreng", stock: 10)
    let outOfStockMenu = MenuModel(name: "Mie Goreng Super Duper Panjang Habis", price: 18000, description: "Lagi kosong", category: "Mie", image: "foods", stock: 0)
    
    let openRestaurant = RestaurantModel(name: "Resto Buka Terus", address: "Jl. Ramai No. 1", rating: 4.5, image: "nasi-goreng-44", menuItems: [availableMenu], isOpen: true)
    let closedRestaurant = RestaurantModel(name: "Resto Tutup Dulu", address: "Jl. Sepi No. 9", rating: 3.0, image: "koopi", menuItems: [], isOpen: false, operationalHours: "SEDANG LIBUR")

    return ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            Text("Restaurant Cards").font(.title2.bold())
            HStack(spacing: 15) {
                FoodCardView(restaurant: openRestaurant)
                FoodCardView(restaurant: closedRestaurant)
            }
            
            Divider().padding(.vertical)
            
            Text("Popular Menu Cards").font(.title2.bold())
            HStack(spacing: 15) {
                FoodCardView(menuItem: availableMenu, restaurant: openRestaurant)
                FoodCardView(menuItem: outOfStockMenu, restaurant: openRestaurant)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
    .environmentObject(UserSession())
    .environmentObject(CartViewModel(userSession: UserSession()))
}
