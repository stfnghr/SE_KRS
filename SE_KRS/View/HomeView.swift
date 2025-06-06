import SwiftUI

struct HomeView: View { //
    @State var search: String = ""
    
    // Data dummy (sebaiknya dari ViewModel)
    let dummyRestaurants: [RestaurantModel] = [
        RestaurantModel(id: UUID(), name: "Nasi Goreng Jaya", address: "Jl. Raya Kemenangan No. 1", rating: 4.8, image: "nasi-goreng-44",
                        menuItems: [ // << PERBAIKAN: Gunakan menuItems (array)
                            MenuModel(name: "Nasi Goreng Spesial Jaya", price: 22000, description: "Nasgor andalan", category: "Nasi", image: "nasi-goreng", stock: 10),
                            MenuModel(name: "Mie Goreng Jaya", price: 21000, description: "Mie favorit", category: "Mie", image: "foods", stock: 8)
                        ], isOpen: true),
        RestaurantModel(id: UUID(), name: "Bubur Ayam Nikmat", address: "Jl. Pagi Hari No. 2", rating: 4.5, image: "bubur-ayam-sby",
                        menuItems: [ // << PERBAIKAN
                            MenuModel(name: "Bubur Ayam Komplit Nikmat", price: 15000, description: "Bubur hangat", category: "Bubur", image: "bubur-ayam-ori", stock: 15)
                        ], isOpen: true),
        RestaurantModel(id: UUID(), name: "Warung Sedang Tutup", address: "Jl. Istirahat No. X", rating: 4.0, image: "foods",
                        menuItems: [], isOpen: false, operationalHours: "TUTUP HARI INI"), // Resto tutup
        RestaurantModel(id: UUID(), name: "Kopi Senja Menyala", address: "Jl. Sore No. 3", rating: 4.9, image: "koopi",
                        menuItems: [ // << PERBAIKAN
                            MenuModel(name: "Kopi Susu Gula Aren Senja", price: 18000, description: "Kopi pilihan", category: "Kopi", image: "kopi-gula-aren", stock: 20),
                            MenuModel(name: "Americano Dingin", price: 15000, description: "Segar", category: "Kopi", image: "kopi-gula-aren", stock: 0) // Stok habis
                        ], isOpen: true)
    ]
    
    let popularMenus: [MenuModel] = [ //
        MenuModel(id: UUID(), name: "Nasi Goreng Populer", price: 23000, description: "Populer dan enak", category: "Nasi", image: "nasi-goreng", stock: 5), //
        MenuModel(id: UUID(), name: "Ayam Geprek Viral", price: 20000, description: "Pedasnya nampol", category: "Ayam", image: "foods", stock: 0), //
        MenuModel(id: UUID(), name: "Es Kopi Kekinian", price: 22000, description: "Wajib coba", category: "Kopi", image: "kopi-gula-aren", stock: 10), //
        MenuModel(id: UUID(), name: "Bubur Ayam Legend", price: 16000, description: "Resep turun temurun", category: "Bubur", image: "bubur-ayam-ori", stock: 12), //
        MenuModel(id: UUID(), name: "Mie Kuah Nendang", price: 18000, description: "Hangat dan lezat", category: "Mie", image: "foods", stock: 7), //
        MenuModel(id: UUID(), name: "Roti Bakar Cokelat Keju", price: 15000, description: "Manis gurih", category: "Roti", image: "koopi", stock: 9) //
    ]
    
    // dummyRestaurantForPopularMenu sekarang hanya membutuhkan struktur dasar RestaurantModel,
    // karena menu item spesifiknya akan datang dari popularMenus
    let dummyRestaurantPlaceholder = RestaurantModel(id: UUID(), name: "Popular Spot", address: "Various", rating: 0, image: "foods", menuItems: []) //


    var body: some View { //
        NavigationStack {
            ZStack { //
                Color.red.ignoresSafeArea(.all) //
                Rectangle().fill(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)).cornerRadius(30).padding(.top, 250).ignoresSafeArea(.all) //

                VStack(spacing: 0) { //
                    SearchBarView(search: $search) //
                        .padding(.top, 160)
                        .padding(.bottom, 10)
                    
                    ScrollView { //
                        VStack(spacing: 20) {
                            ImageCarouselView() // Pemanggilan yang benar
                            RestoSekitarmuSection(restaurants: dummyRestaurants)
                            PilihMakananmuSection(popularMenus: popularMenus, dummyRestaurant: dummyRestaurantPlaceholder)
                        }
                        .padding(.bottom, 80)
                    }
                }
                .padding(.horizontal, 10) //
            }
        }
        .tint(.black) //
    }
}

// MARK: - Subview untuk SearchBar (Pastikan ini ada di file ini atau file terpisah)
struct SearchBarView: View { //
    @Binding var search: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray).padding(.leading, 15)
            TextField("Lagi mau makan apa?", text: $search).font(.system(size: 14)).padding(.vertical, 12)
            if !search.isEmpty {
                Button(action: { search = "" }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding(.trailing, 15)
            }
        }
        .frame(width: 335, height: 40)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 5, x: 0, y: 1)
        .padding(.horizontal)
    }
}

// MARK: - Subview untuk Image Carousel (Pastikan ini ada)
struct ImageCarouselView: View { //
    @State var currentPage: Int? = 0
    let carouselImages = ["foods", "nasi-goreng-44", "koopi", "bubur-ayam-sby"]

    var body: some View {
        ZStack {
            Rectangle().fill(Color.clear).frame(height: 150).cornerRadius(30)
                .overlay(
                    GeometryReader { geometry in
                        let pageWidth = geometry.size.width
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(0..<carouselImages.count, id: \.self) { index in
                                    Image(carouselImages[index])
                                        .resizable().scaledToFill().frame(width: pageWidth, height: 150)
                                        .cornerRadius(30).clipped().id(index)
                                }
                            }.scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.paging)
                        .scrollPosition(id: $currentPage)
                    }
                ).padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(0..<carouselImages.count, id: \.self) { index in
                    Circle().fill(currentPage == index ? Color.orange : Color.gray.opacity(0.4)).frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 6).padding(.horizontal, 12).background(Color.white).cornerRadius(20).padding(.top, 120)
        }
    }
}


// Ganti struct RestoSekitarmuSection
struct RestoSekitarmuSection: View {
    var restaurants: [RestaurantModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) { Text("Resto Sekitarmu").font(.headline); Text("Kami pilihin tempat yang lagi buka dan enak.").font(.caption).foregroundColor(.orange) }
                Spacer()
                NavigationLink(destination: AllRestaurantsView(restaurants: restaurants)) {
                    Text("Lihat Semua").font(.caption).fontWeight(.bold).foregroundColor(.white).padding(.vertical, 8).padding(.horizontal, 15).background(Color.red).cornerRadius(25)
                }
            }.padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(restaurants) { restaurant in
                        // --- REVISI PEMANGGILAN ---
                        // Kita panggil init yang benar dan hapus .whiteCard
                        FoodCardView(restaurant: restaurant)
                    }
                }.padding(.horizontal)
            }
        }
    }
}


struct PilihMakananmuSection: View {
    var popularMenus: [MenuModel]
    var dummyRestaurant: RestaurantModel
    
    // REVISI: Mengatur grid dengan kolom yang ukurannya fleksibel
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) { Text("Pilih Makananmu").font(.headline); Text("Kita sediakan pilihan makanan untuk kamu.").font(.caption).foregroundColor(.orange) }
                Spacer()
                NavigationLink(destination: AllFoodsView(popularMenus: popularMenus, dummyRestaurant: dummyRestaurant)) {
                     Text("Lihat Semua").font(.caption).fontWeight(.bold).foregroundColor(.white).padding(.vertical, 8).padding(.horizontal, 15).background(Color.red).cornerRadius(25)
                }
            }.padding(.horizontal).padding(.top)
            
            // REVISI: Kembali menggunakan LazyVGrid untuk layout yang lebih baik
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(popularMenus.prefix(4)) { menu_item in // Hanya tampilkan 4 item di home
                    FoodCardView(menuItem: menu_item, restaurant: dummyRestaurant)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview { //
    HomeView()
        .environmentObject(CartViewModel(userSession: UserSession()))
        // .environmentObject(RestaurantViewModel()) // Jika RestaurantViewModel digunakan
        .environmentObject(UserSession()) // Untuk UserSession jika diperlukan oleh subview lain
}
