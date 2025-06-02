import SwiftUI

struct MenuCardView: View {
    var menuItem: MenuModel
    @EnvironmentObject var cartViewModel: CartViewModel

    @State var isLiked = false
    @State private var showingAddedToCartAlert = false
    @State private var showingOutOfStockAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Group {
            if menuItem.isAvailable {
                NavigationLink(destination: DetailMenuView(menuItem: self.menuItem)) {
                    menuCardContent()
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                menuCardContent()
                    .onTapGesture {
                        self.alertMessage = "Maaf, \(menuItem.name) stoknya habis."
                        self.showingOutOfStockAlert = true
                    }
            }
        }
        .alert(isPresented: $showingAddedToCartAlert) {
            Alert(title: Text("Ditambahkan"), message: Text("\(menuItem.name) telah ditambahkan ke keranjang."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingOutOfStockAlert) {
            Alert(title: Text("Stok Habis"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    @ViewBuilder
    private func menuCardContent() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .cornerRadius(25)
                .shadow(radius: 3, x: 0, y: 5)
                .opacity(menuItem.isAvailable ? 1.0 : 0.6)

            HStack {
                Image(menuItem.image.isEmpty ? "foods" : menuItem.image)
                    .resizable().scaledToFill()
                    .frame(width: 100, height: 100).clipped().cornerRadius(20)
                    .padding(.leading, 5)
                    .overlay(
                        !menuItem.isAvailable ? Color.black.opacity(0.4).cornerRadius(20) : nil
                    )

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(menuItem.name).font(.system(size: 17, weight: .semibold)).lineLimit(1)
                        Spacer()
                        Button(action: { withAnimation(.spring()) { isLiked.toggle() }}) {
                            Image(systemName: isLiked ? "heart.fill" : "heart").foregroundColor(.red).font(.system(size: 18))
                        }
                    }
                    Text(menuItem.description).font(.system(size: 10)).foregroundColor(.orange).lineLimit(2)
                    Spacer()
                    HStack {
                        Text("Rp\(String(format: "%.0f", menuItem.price))")
                            .font(.system(size: 14)).fontWeight(.semibold).foregroundColor(.red)
                        Spacer()
                        Button(action: {
                            if menuItem.isAvailable {
                                cartViewModel.addItemToCart(menuItem: menuItem)
                                showingAddedToCartAlert = true
                            } else {
                                self.alertMessage = "Maaf, \(menuItem.name) stoknya habis."
                                self.showingOutOfStockAlert = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "cart.fill").font(.system(size: 12))
                                Text(menuItem.isAvailable ? "Add" : "Habis")
                                    .font(.system(size: 12))
                            }
                            .fontWeight(.bold).foregroundColor(.white)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(menuItem.isAvailable ? Color.red : Color.gray)
                            .cornerRadius(25)
                        }
                        .disabled(!menuItem.isAvailable)
                    }
                }
                .padding(.trailing, 15).padding(.vertical, 8)
            }
            .padding(.leading, 5)
            
            if !menuItem.isAvailable {
                 Text("STOK HABIS")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(5)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview("MenuCardView_States") {
    let availableMenuItem = MenuModel(id: UUID(), name: "Nasi Goreng Enak", price: 22000, description: "Nasi goreng spesial dengan telur mata sapi.", category: "Nasi", image: "nasi-goreng", stock: 5)
    let outOfStockMenuItem = MenuModel(id: UUID(), name: "Mie Ayam Habis", price: 18000, description: "Mie ayam spesial, lagi kosong.", category: "Mie", image: "foods", stock: 0)
    
    let userSession = UserSession()
    let cartVM = CartViewModel(userSession: userSession)

    return ScrollView {
        VStack {
            MenuCardView(menuItem: availableMenuItem)
            MenuCardView(menuItem: outOfStockMenuItem)
        }
        .environmentObject(cartVM)
        .padding()
    }
}
