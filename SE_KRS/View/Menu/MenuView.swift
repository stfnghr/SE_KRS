// File: View/MenuView.swift (FINAL - Navigation & Cart Fixed with YOUR MenuCardView)
import SwiftUI

struct MenuView: View {
    var restaurant: RestaurantModel
    // CartViewModel akan di-pass ke MenuCardView dan DetailMenuView via environment
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: String
    
    // State untuk alert sudah tidak diperlukan di MenuView, karena ditangani di MenuCardView/DetailMenuView
    // @State private var showAlert = false
    // @State private var alertMessage = ""

    private var categories: [String]
    
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        let menuCategories = Array(Set(restaurant.menuItems.map { $0.category })).sorted()
        self.categories = ["Semua"] + menuCategories
        self._selectedCategory = State(initialValue: "Semua")
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("Beige").ignoresSafeArea() // Latar belakang utama

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView
                    contentContainer
                }
            }
            .scrollContentBackground(.hidden)
            .ignoresSafeArea(edges: .top)
            
            backButton
        }
        .navigationBarHidden(true)
        // .alert() sudah tidak diperlukan di sini
    }
}

// MARK: - Subviews
extension MenuView {
    
    private var headerView: some View {
        Image(restaurant.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 250) // Anda bisa sesuaikan tinggi ini jika perlu
            .overlay(
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]), startPoint: .center, endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .font(.largeTitle).bold()
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text(String(format: "%.1f", restaurant.rating))
                            Text("• 20-30 min")
                        }
                        .font(.subheadline).fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom, 20) // Menambah padding bawah agar teks tidak terlalu mepet
                }
            )
            .clipped() // Pastikan gambar tidak keluar dari frame header
    }
    
    private var contentContainer: some View {
        // Wadah utama untuk semua konten di bawah header
        VStack(alignment: .leading, spacing: 0) {
            // Category Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) { // Jarak antar tab
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            withAnimation(.easeInOut) { selectedCategory = category }
                        }) {
                            Text(category)
                                .font(.subheadline).bold()
                                .padding(.vertical, 8)
                                .foregroundColor(selectedCategory == category ? .red : .secondary)
                                .overlay(Rectangle().frame(height: 2).foregroundColor(selectedCategory == category ? .red : .clear), alignment: .bottom)
                        }
                    }
                }
            }
            .padding(.top, 24) // Padding antara atas area putih & tabs
            .padding(.horizontal, 20) // Padding kiri-kanan untuk tabs

            // Section Header
            Text(selectedCategory)
                .font(.title2).bold()
                .padding(.top, 24)
                .padding(.horizontal, 20) // Padding kiri-kanan untuk section header
            
            // Menu List
            let items = restaurant.menuItems.filter {
                selectedCategory == "Semua" ? true : $0.category == selectedCategory
            }
            
            LazyVStack(alignment: .leading, spacing: 0) {
                if items.isEmpty {
                    Text("Menu untuk kategori ini belum tersedia.")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 50)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                } else {
                    ForEach(items) { item in
                        // --- REVISI UTAMA DI SINI ---
                        NavigationLink(destination: DetailMenuView(menuItem: item)
                                        // Pastikan DetailMenuView juga mendapatkan cartViewModel
                                        .environmentObject(cartViewModel)
                        ) {
                            // Panggil MenuCardView sesuai definisi Anda (tanpa onAdd closure)
                            MenuCardView(menuItem: item)
                        }
                        .buttonStyle(PlainButtonStyle()) // Agar seluruh area kartu bisa diklik
                        .padding(.horizontal, 20) // Padding kiri-kanan untuk setiap MenuCardView
                        // Garis pemisah jika diperlukan (MenuCardView Anda sudah punya divider di dalam)
                        // Divider().padding(.leading, 20)
                    }
                }
            }
            Spacer() // Mendorong konten ke atas jika pendek
        }
        .padding(.bottom, 50) // Padding bawah setelah semua konten
        .background(Color.white)
        .cornerRadius(25, corners: [.topLeft, .topRight])
        .offset(y: -25)
    }
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
        .padding(.leading)
        .padding(.top, 45) // Sesuaikan dengan safe area atas
    }
}

// Helper (pastikan ini ada di proyek Anda jika belum)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity; var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)); return Path(path.cgPath)
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    let menu = [
        MenuModel(name: "Nasi Goreng Spesial", price: 25000, description: "Dengan telur, sosis, dan ayam suwir.", category: "Nasi", image: "nasi-goreng", stock: 10),
        MenuModel(name: "Es Teh Manis", price: 5000, description: "Teh segar pelepas dahaga.", category: "Minuman", image: "kopi-gula-aren", stock: 20)
    ]
    let resto = RestaurantModel(name: "Nasi Goreng Jaya", address: "Jl. Digital No. 1", rating: 4.8, image: "nasi-goreng-44", menuItems: menu, isOpen: true)
    
    return NavigationView {
        MenuView(restaurant: resto)
            .environmentObject(CartViewModel(userSession: UserSession()))
    }
}
