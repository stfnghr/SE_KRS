// File: View/MenuCardView.swift (REVISED)
import SwiftUI

struct MenuCardView: View {
    var menuItem: MenuModel
    @EnvironmentObject var cartViewModel: CartViewModel

    // State untuk UI
    @State private var isLiked = false
    
    // State untuk notifikasi
    @State private var showingAddedToCartAlert = false
    @State private var showingOutOfStockAlert = false
    @State private var alertMessage = ""

    var body: some View {
        HStack(spacing: 15) {
            // --- Gambar Item Menu ---
            Image(menuItem.image.isEmpty ? "foods" : menuItem.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .cornerRadius(15)
                .clipped()
                .opacity(menuItem.isAvailable ? 1.0 : 0.6)

            // --- Detail Item Menu ---
            VStack(alignment: .leading, spacing: 4) {
                // Baris 1: Nama & Tombol Suka
                HStack {
                    Text(menuItem.name)
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    Button(action: { isLiked.toggle() }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }

                // Baris 2: Deskripsi
                Text(menuItem.description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Spacer() // Mendorong baris harga & tombol ke bawah

                // Baris 3: Harga & Tombol Tambah
                HStack {
                    Text("Rp. \(String(format: "%.0f", menuItem.price))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                    Spacer()
                    addButton
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 4)
        .alert(isPresented: $showingAddedToCartAlert) {
            Alert(title: Text("Berhasil"), message: Text("\(menuItem.name) telah ditambahkan ke keranjang."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingOutOfStockAlert) {
            Alert(title: Text("Stok Habis"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // View untuk tombol "Add" agar lebih rapi
    @ViewBuilder
    private var addButton: some View {
        Button(action: {
            if menuItem.isAvailable {
                cartViewModel.addItemToCart(menuItem: menuItem)
                showingAddedToCartAlert = true
            } else {
                alertMessage = "Maaf, \(menuItem.name) stoknya habis."
                showingOutOfStockAlert = true
            }
        }) {
            Label(menuItem.isAvailable ? "Add" : "Habis", systemImage: "cart.badge.plus")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(menuItem.isAvailable ? Color.red : Color.gray)
                .cornerRadius(10)
        }
        .disabled(!menuItem.isAvailable)
    }
}


#Preview {
    let availableMenuItem = MenuModel(id: UUID(), name: "Nasi Goreng Enak", price: 22000, description: "Nasi goreng spesial dengan telur mata sapi dan topping melimpah.", category: "Nasi", image: "nasi-goreng", stock: 5)
    let outOfStockMenuItem = MenuModel(id: UUID(), name: "Mie Ayam Habis", price: 18000, description: "Mie ayam spesial, sayangnya lagi kosong.", category: "Mie", image: "foods", stock: 0)

    let userSession = UserSession()
    let cartVM = CartViewModel(userSession: userSession)

    return ScrollView {
        VStack(spacing: 15) {
            MenuCardView(menuItem: availableMenuItem)
            MenuCardView(menuItem: outOfStockMenuItem)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .environmentObject(cartVM)
    }
}
