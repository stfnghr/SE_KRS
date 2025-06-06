// File: View/DetailMenuView.swift (FINAL REVISION TO MATCH LATEST SCREENSHOT)
import SwiftUI

struct DetailMenuView: View {
    var menuItem: MenuModel // Data dari menu yang dipilih
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode

    // State untuk kuantitas
    @State private var quantity: Int = 1
    
    // State untuk alert (menggunakan alert standar SwiftUI untuk kesederhanaan)
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var isLiked = false // Untuk tombol hati

    // Warna dominan dari referensi (bisa disesuaikan)
    let primaryTextColor = Color.black.opacity(0.85)
    let secondaryTextColor = Color.gray
    let actionButtonColor = Color.black.opacity(0.9) // Warna tombol "Add to cart"

    var body: some View {
        ZStack {
            // Latar belakang putih solid
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Navigation Bar (hanya tombol back)
                customNavBar
                    .padding(.bottom, 8) // Sedikit jarak dari gambar

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) { // Spasi antar elemen utama
                        // 1. Gambar Produk & Paging Dots
                        productImageAndPaging

                        // 2. Area Konten Utama
                        mainContent
                            .padding(.horizontal, 24)
                    }
                    // Padding bawah untuk memberi ruang dari bottom action bar
                    .padding(.bottom, 150)
                }
            }
            
            // 3. Bottom Action Bar (menempel di bawah)
            bottomActionBar
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .navigationBarHidden(true) // Sembunyikan navigation bar default
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Subviews Sesuai Referensi
extension DetailMenuView {

    private var customNavBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2.weight(.semibold)) // Ikon lebih tebal
                    .foregroundColor(primaryTextColor)
            }
            Spacer()
            // Tidak ada judul di navbar ini sesuai referensi
        }
        .padding(.horizontal, 24)
    }

    private var productImageAndPaging: some View {
        VStack(spacing: 16) {
            Image(menuItem.image.isEmpty ? "foods" : menuItem.image)
                .resizable()
                .aspectRatio(contentMode: .fit) // Agar gambar tidak terdistorsi
                .frame(height: 200) // Tinggi gambar disesuaikan
                .cornerRadius(20) // Ini yang memberikan corner radius
                .shadow(color: .black.opacity(0.03), radius: 5, y: -2)
        }
    }

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 16) { // Spasi antar elemen info
            // Kategori produk (misalnya "NASI" dari referensi)
            Text(menuItem.category.uppercased())
                .font(.footnote.weight(.semibold))
                .foregroundColor(secondaryTextColor)

            HStack(alignment: .top) {
                Text(menuItem.name)
                    .font(.system(size: 28, weight: .bold)) // Ukuran font nama produk
                    .foregroundColor(primaryTextColor)
                    .fixedSize(horizontal: false, vertical: true) // Agar teks wrap
                
                Spacer()
                
                // Tombol Kuantitas
                HStack(spacing: 14) { // Jarak antar tombol +/- dan angka
                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                        Image(systemName: "minus")
                            .font(.system(size: 16, weight: .bold)) // Ukuran ikon +/-
                            .foregroundColor(primaryTextColor)
                            .frame(width: 38, height: 38)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Text("\(quantity)")
                        .font(.title2.weight(.bold))
                        .foregroundColor(primaryTextColor)
                    Button(action: { quantity += 1 }) {
                        Image(systemName: "plus")
                             .font(.system(size: 16, weight: .bold))
                            .foregroundColor(primaryTextColor)
                            .frame(width: 38, height: 38)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }

            Text(menuItem.description.isEmpty ? "Deskripsi produk belum tersedia." : menuItem.description)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(secondaryTextColor)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true) // Agar teks wrap

            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .foregroundColor(secondaryTextColor)
                Text("Delivery Time")
                    .foregroundColor(secondaryTextColor)
                Text("30 min") // Data dummy
                    .fontWeight(.medium)
                    .foregroundColor(primaryTextColor)
            }
            .font(.subheadline)
        }
    }

    private var bottomActionBar: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Price")
                    .font(.caption)
                    .foregroundColor(secondaryTextColor)
                Text("Rp. \(String(format: "%.0f", menuItem.price * Double(quantity)))")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(primaryTextColor)
            }

            Spacer()

            Button(action: { isLiked.toggle() }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isLiked ? .red : secondaryTextColor) // Warna hati berubah jika disukai
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }

            Button(action: {
                if menuItem.isAvailable {
                    cartViewModel.addItemToCart(menuItem: menuItem, quantity: quantity)
                    alertTitle = "Berhasil"
                    alertMessage = "\(quantity)x \(menuItem.name) ditambahkan."
                    showAlert = true
                } else {
                    alertTitle = "Stok Habis"
                    alertMessage = "Maaf, \(menuItem.name) stoknya habis."
                    showAlert = true
                }
            }) {
                VStack(spacing: 2) {
                    Image(systemName: "cart")
                    Text("Add to cart")
                }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .frame(minWidth: 110)
                .background(menuItem.isAvailable ? actionButtonColor : Color.gray)
                .cornerRadius(12)
            }
            .disabled(!menuItem.isAvailable)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 34)
        .background(.white)
    }
}

#Preview("DetailMenuView Referensi Baru") {
    let previewMenuItem = MenuModel(
        name: "Nasi Goreng Spesial Dengan Bumbu Rahasia Super Panjang Sekali",
        price: 25000,
        description: "Dengan telur, sosis, dan ayam suwir. Deskripsi ini dibuat cukup panjang untuk menguji bagaimana teks akan wrap dan apakah ada bagian yang terpotong atau tidak dalam tampilan UI yang sudah diperbaiki.",
        category: "NASI",
        image: "nasi-goreng",
        stock: 5
    )
    
    return NavigationView {
        DetailMenuView(menuItem: previewMenuItem)
            .environmentObject(CartViewModel(userSession: UserSession()))
    }
}
