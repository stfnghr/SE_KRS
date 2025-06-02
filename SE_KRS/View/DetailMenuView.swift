import SwiftUI

struct DetailMenuView: View {
    var menuItem: MenuModel
    @EnvironmentObject var cartViewModel: CartViewModel

    @State private var showingAddedToCartAlert = false
    @State private var showingOutOfStockAlert = false
    @State private var alertMessage = ""


    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)
                .ignoresSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 15) {
                    Image(menuItem.image.isEmpty ? "foods" : menuItem.image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                         .overlay( // Overlay jika habis
                            !menuItem.isAvailable ? Color.black.opacity(0.5) : nil
                         )
                    
                    if !menuItem.isAvailable {
                        Text("STOK HABIS")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 15)
                            .background(Color.red)
                            .cornerRadius(8)
                            .offset(y: -30) // Tarik ke atas sedikit
                    }

                    VStack (alignment: .leading, spacing: 8) {
                        Text(menuItem.name)
                            .font(.largeTitle).fontWeight(.bold) // Font lebih besar
                        
                        Text(menuItem.description)
                            .font(.body).foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)

                    HStack {
                        Text("Rp\(String(format: "%.0f", menuItem.price))")
                            .font(.title2).fontWeight(.semibold).foregroundColor(.red)
                        
                        Spacer()
                        
                        Button(action: {
                            if menuItem.isAvailable {
                                cartViewModel.addItemToCart(menuItem: menuItem)
                                self.alertMessage = "\(menuItem.name) telah ditambahkan ke keranjang."
                                self.showingAddedToCartAlert = true
                            } else {
                                self.alertMessage = "Maaf, \(menuItem.name) stoknya habis."
                                self.showingOutOfStockAlert = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "cart.fill").font(.system(size: 14)).fontWeight(.bold)
                                Text(menuItem.isAvailable ? "Tambahkan ke Keranjang" : "Stok Habis")
                                    .font(.system(size: 13)).fontWeight(.medium)
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 44)
                        }
                        .foregroundColor(.white)
                        .background(menuItem.isAvailable ? Color.red : Color.gray)
                        .cornerRadius(25)
                        .disabled(!menuItem.isAvailable)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle(menuItem.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAddedToCartAlert) {
            Alert(title: Text("Ditambahkan"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingOutOfStockAlert) {
            Alert(title: Text("Stok Habis"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview("DetailMenuView_States") {
    let availableMenuItem = MenuModel(id: UUID(), name: "Nasi Goreng Detail", price: 27500, description: "Ini adalah deskripsi panjang untuk nasi goreng spesial yang sangat enak, dibuat dengan bumbu rahasia dan disajikan dengan penuh cinta.", category: "Nasi", image: "nasi-goreng", stock: 3)
    let outOfStockMenuItem = MenuModel(id: UUID(), name: "Soto Ayam Detail (Habis)", price: 27500, description: "Soto ayam legendaris, sayangnya lagi kosong.", category: "Soto", image: "foods", stock: 0)
    
    let userSession = UserSession()
    let cartVM = CartViewModel(userSession: userSession)

    return NavigationView {
        VStack {
            Text("Item Tersedia:").font(.caption)
            DetailMenuView(menuItem: availableMenuItem)
                .environmentObject(cartVM)
            Divider()
            Text("Item Habis Stok:").font(.caption)
            DetailMenuView(menuItem: outOfStockMenuItem)
                .environmentObject(cartVM)
        }
    }
}
