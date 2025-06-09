// File: View/Menu/MenuCardView.swift (REVISED)
import SwiftUI

struct MenuCardView: View {
    var menuItem: MenuModel
    // userSession diakses melalui cartViewModel
    @EnvironmentObject var cartViewModel: CartViewModel

    // State untuk UI
    @State private var isLiked = false
    
    // State untuk notifikasi (hanya untuk stok habis)
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
        // Alert untuk item berhasil ditambahkan sudah dihapus, karena kita pakai notifikasi global
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
                
                // --- PERUBAHAN: MEMICU NOTIFIKASI GLOBAL ---
                // Menggunakan sistem notifikasi yang sama seperti saat login.
                cartViewModel.userSession.statusNotificationMessage = "\(menuItem.name) ditambahkan!"
                cartViewModel.userSession.showStatusNotification = true

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
