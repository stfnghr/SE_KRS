// File: View/MenuView.swift
import SwiftUI

struct MenuView: View { //
    // Terima RestaurantModel untuk menampilkan menu spesifik restoran
    var restaurant: RestaurantModel
    
    // @StateObject var cartViewModel = CartViewModel(userSession: UserSession()) // Atau inject dari environment
    // Data menu akan diambil dari restaurant.menuItems atau logika lain
    // Untuk contoh, kita asumsikan RestaurantModel memiliki array menuItems
    // Jika RestaurantModel Anda hanya punya satu `menu: MenuModel`, Anda perlu menyesuaikan ini.
    // Mari kita asumsikan ada daftar menu yang bisa diakses dari restaurant, atau kita buat dummy.
    
    // Dummy menu items untuk restoran ini (gantilah dengan data asli dari restaurant.menuItems jika ada)
    let exampleMenuItems: [MenuModel] = [
        MenuModel(id: UUID(), name: "Nasi Goreng Spesial Resto", price: 28000, description: "Nasi goreng khas resto ini.", category: "Nasi", image: "nasi-goreng"),
        MenuModel(id: UUID(), name: "Ayam Bakar Madu", price: 35000, description: "Ayam bakar dengan bumbu madu.", category: "Ayam", image: "foods"),
        MenuModel(id: UUID(), name: "Es Jeruk Segar", price: 12000, description: "Es jeruk peras murni.", category: "Minuman", image: "kopi-gula-aren") // Ganti gambar
    ]


    @State var isSelected = false //
    @State private var selectedButtonIndex: Int = 0 //
    let menuItemsFilter = ["Semua", "Makanan", "Minuman", "Lainnya"] // Ubah filter items // (Dulu Food, Drink, Others)

    var filteredMenuItems: [MenuModel] {
        // Implementasi filter berdasarkan selectedButtonIndex
        // Untuk sekarang, kita tampilkan semua saja dari exampleMenuItems
        // Anda perlu menambahkan logika filter berdasarkan `menuItemsFilter[selectedButtonIndex]`
        // dan kategori di `MenuModel`.
        switch menuItemsFilter[selectedButtonIndex] {
        case "Makanan":
            return exampleMenuItems.filter { $0.category == "Nasi" || $0.category == "Ayam" || $0.category == "Bubur" } // Contoh
        case "Minuman":
            return exampleMenuItems.filter { $0.category == "Minuman" || $0.category == "Kopi" }
        case "Semua":
            return exampleMenuItems
        default:
            return exampleMenuItems.filter { $0.category == menuItemsFilter[selectedButtonIndex] }
        }
    }

    var body: some View { //
        // NavigationStack { // Tidak perlu jika sudah di dalam NavStack dari HomeView
            ZStack { //
                // beige
                Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255) //
                    .ignoresSafeArea(.container) //

                Rectangle() //
                    // medium-orange
                    .fill(Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255)) //
                    .frame(height: 300) // Disesuaikan
                    .offset(y: -UIScreen.main.bounds.height / 2.5) // Geser ke atas
                    // .cornerRadius(100) //
                    // .padding(.bottom, 700) // Dihapus agar lebih fleksibel dengan offset

                ScrollView { //
                    MenuOutletCardView(restaurant: self.restaurant) // Tampilkan info restoran yang dipilih
                        .padding(.top, 100) // Sesuaikan padding agar tidak terlalu jauh

                    HStack(spacing: 10) { //
                        ForEach(0..<menuItemsFilter.count, id: \.self) { index in //
                            Button(action: { //
                                withAnimation(.easeInOut) { selectedButtonIndex = index } //
                            }) {
                                ZStack { //
                                    RoundedRectangle(cornerRadius: 30).fill(selectedButtonIndex == index ? .red : .clear) //
                                        .frame(minWidth: 80, idealHeight: 30) // Lebar fleksibel
                                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(selectedButtonIndex == index ? .clear : .red, lineWidth: 1)) //
                                    Text(menuItemsFilter[index]).foregroundColor(selectedButtonIndex == index ? .white : .red).font(.system(size: 14)).padding(.horizontal, 10) //
                                }
                            }
                            .buttonStyle(.plain) //
                        }
                    }
                    .padding(.horizontal) // Padding untuk HStack filter

                    HStack { //
                        Text(menuItemsFilter[selectedButtonIndex]) // Tampilkan judul kategori yang dipilih
                            .font(.system(size: 20, weight: .semibold)) //
                        Spacer() //
                    }
                    .padding(.horizontal, 20) //
                    .padding(.top, 20) //

                    if filteredMenuItems.isEmpty {
                        Text("Menu belum tersedia untuk kategori ini.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        VStack(spacing: 10) { // Beri jarak antar MenuCardView //
                            ForEach(filteredMenuItems) { menuItemData in // Loop dari data menu restoran
                                MenuCardView(menuItem: menuItemData) // Teruskan data menu yang benar //
                                    // .padding(.vertical, 3) // Padding bisa diatur di MenuCardView
                            }
                        }
                        .padding(.bottom, 20) // Padding bawah untuk konten
                    }
                }
            }
            .navigationTitle(restaurant.name) // Judul halaman adalah nama restoran
            .navigationBarTitleDisplayMode(.inline) // Atau .large
        // } // End NavigationStack
    }
}

// Extension untuk cornerRadius sudah ada di kode Anda
