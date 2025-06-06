import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct FoodCardView: View {
    var menu: MenuModel
    var restaurant: RestaurantModel
    
    @State private var showingRestaurantClosedAlert = false
    @State private var alertMessage = ""
    @State private var showingOutOfStockAlert = false // Untuk redCard
    
    var body: some View {
        if restaurant.menuItems.isEmpty && !menu.name.isEmpty {
             redCard(menuItem: menu)
        } else if !restaurant.name.isEmpty {
             whiteCard(restaurant: restaurant)
        } else {
            // Fallback atau error view jika data tidak lengkap
            Text("Data tidak valid untuk FoodCardView")
        }
    }
    
    @ViewBuilder
    func whiteCard(restaurant: RestaurantModel) -> some View {
        Group {
            if restaurant.isOpen {
                NavigationLink(destination: MenuView(restaurant: restaurant)) {
                    restaurantCardContent(restaurant: restaurant, isOpen: true)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                restaurantCardContent(restaurant: restaurant, isOpen: false)
                    .onTapGesture {
                        self.alertMessage = "Maaf, resto \(restaurant.name) lagi tutup (${restaurant.operationalHours}). Coba cari resto yang lain."
                        self.showingRestaurantClosedAlert = true
                    }
            }
        }
        .alert(isPresented: $showingRestaurantClosedAlert) {
            Alert(title: Text("Restoran Tutup"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    @ViewBuilder
    private func restaurantCardContent(restaurant: RestaurantModel, isOpen: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(15)
                .frame(width: 175, height: 175)
                .shadow(radius: 3, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 0) {
                Image(restaurant.image.isEmpty ? "foods" : restaurant.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 110)
                    .clipped()
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .overlay(
                        !isOpen ? Color.black.opacity(0.5).cornerRadius(15, corners: [.topLeft, .topRight]) : nil
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    HStack {
                        Image(systemName: "star.fill").foregroundColor(.orange).font(.caption)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    if !isOpen {
                        Text(restaurant.operationalHours.uppercased())
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .cornerRadius(4)
                            .offset(y: -28)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(height: 65)
            }
        }
        .opacity(isOpen ? 1.0 : 0.7)
    }

    @ViewBuilder
    func redCard(menuItem: MenuModel) -> some View {
        Group {
            if menuItem.isAvailable {
                NavigationLink(destination: DetailMenuView(menuItem: menuItem)) {
                    menuItemCardContent(menuItem: menuItem)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                menuItemCardContent(menuItem: menuItem)
                    .onTapGesture {
                        self.alertMessage = "Maaf, \(menuItem.name) stoknya habis."
                        self.showingOutOfStockAlert = true
                    }
            }
        }
        .alert(isPresented: $showingOutOfStockAlert) {
            Alert(title: Text("Stok Habis"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    @ViewBuilder
    private func menuItemCardContent(menuItem: MenuModel) -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(menuItem.isAvailable ? Color.red : Color.gray.opacity(0.7))
                .cornerRadius(15)
                .frame(width: 105, height: 100)
                .shadow(radius: 3, x: 0, y: 5)

            VStack(alignment: .center, spacing: 2) {
                Image(menuItem.image.isEmpty ? "foods" : menuItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 105, height: 60)
                    .clipped()
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                     .overlay(
                        !menuItem.isAvailable ? Color.black.opacity(0.5).cornerRadius(15, corners: [.topLeft, .topRight]) : nil
                     )
                
                Text(menuItem.name) // Tampilkan nama menu
                    .font(.system(size: 12, weight: .semibold)) // Ukuran disesuaikan
                    .foregroundColor(.white)
                    .lineLimit(2) // Biarkan dua baris jika nama panjang
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                
                if !menuItem.isAvailable {
                    Text("HABIS")
                        .font(.caption2.bold())
                        .foregroundColor(Color.red)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(3)
                }
            }
            .padding(.bottom, 5)
        }
        .opacity(menuItem.isAvailable ? 1.0 : 0.7)
    }
}

#Preview("FoodCardView_AllStates") {
    let availableMenu = MenuModel(name: "Nasi Goreng Okay", price: 20000, description: "Enak", category: "Nasi", image: "nasi-goreng", stock: 10)
    let outOfStockMenu = MenuModel(name: "Mie Goreng Habis", price: 18000, description: "Lagi kosong", category: "Mie", image: "foods", stock: 0)
    
    let openRestaurant = RestaurantModel(name: "Resto Buka Terus", address: "Jl. Ramai No. 1", rating: 4.5, image: "nasi-goreng-44", menuItems: [availableMenu], isOpen: true)
    let closedRestaurant = RestaurantModel(name: "Resto Tutup Dulu", address: "Jl. Sepi No. 9", rating: 3.0, image: "koopi", menuItems: [], isOpen: false, operationalHours: "SEDANG LIBUR")

    return ScrollView {
        VStack(spacing: 15) {
            Text("Restaurant Cards").font(.title2).fontWeight(.bold)
            HStack(spacing: 15) {
                FoodCardView(menu: openRestaurant.menuItems.first ?? availableMenu, restaurant: openRestaurant)
                    .whiteCard(restaurant: openRestaurant)
                FoodCardView(menu: closedRestaurant.menuItems.first ?? outOfStockMenu, restaurant: closedRestaurant)
                    .whiteCard(restaurant: closedRestaurant)
            }
            Divider().padding(.vertical)
            Text("Menu Item Cards (Red)").font(.title2).fontWeight(.bold)
            HStack(spacing: 15) {
                FoodCardView(menu: availableMenu, restaurant: openRestaurant)
                    .redCard(menuItem: availableMenu)
                FoodCardView(menu: outOfStockMenu, restaurant: openRestaurant) // Restoran bisa dummy jika hanya info menu
                    .redCard(menuItem: outOfStockMenu)
            }
        }
        .padding()
        .environmentObject(CartViewModel(userSession: UserSession()))
        .environmentObject(UserSession())
    }
}
