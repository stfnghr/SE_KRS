// File: View/CartView.swift
import SwiftUI

struct CartView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var viewModel: CartViewModel
    
    @State private var selectedPaymentMethod: PaymentType = .balance

    var body: some View {
        NavigationStack {
            ZStack { // ZStack for background and loading overlay
                Color("Beige").ignoresSafeArea(.all) // Background consistent with Landing/Login
                
                VStack(spacing: 0) { // Use VStack utama with spacing 0
                    cartHeader() // Header
                        .padding(.horizontal) // Padding agar tidak mepet tepi
                        .padding(.top, 10)

                    Divider().background(.gray.opacity(0.3)).padding(.horizontal) // Garis pemisah yang lebih soft

                    // Logika if/else menggunakan viewModel dari environment
                    if viewModel.activeCart.isEmpty && !viewModel.paymentProcessing {
                        emptyCartView()
                    } else {
                        ScrollView { // Use ScrollView for list item
                            VStack(spacing: 12) { // Spacing antar item
                                ForEach($viewModel.activeCart) { $itemInCart in
                                    CartItemRowFromVM(item: $itemInCart, cartViewModel: viewModel)
                                        .background(Color.white) // Beri background putih pada row
                                        .cornerRadius(15) // Corner radius untuk setiap item row
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2) // Shadow lembut
                                        .padding(.horizontal, 5) // Padding horizontal untuk setiap row
                                }
                                .onDelete(perform: deleteItemsFromVM) // Tetap bisa dihapus
                            }
                            .padding(.top, 15) // Padding di atas daftar item

                            // Ringkasan Pesanan dalam card terpisah
                            orderSummarySection()
                                .padding(.horizontal) // Padding di sini untuk card ringkasan
                                .padding(.top, 20)
                            
                            // Metode Pembayaran
                            paymentMethodPicker()
                                .padding(.horizontal)
                                .padding(.top, 20)

                            Spacer(minLength: 20) // Spacer di akhir ScrollView
                        }
                        .padding(.bottom, 100) // Beri ruang untuk tombol di bawah
                    }
                    Spacer() // Mendorong konten ke atas
                }
                .navigationTitle("Keranjang")
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertTitle),
                          message: Text(viewModel.alertMessage),
                          dismissButton: .default(Text("OK")) {
                        if viewModel.orderProcessedSuccessfully {
                            // Reset after order successful and alert closed
                            viewModel.orderProcessedSuccessfully = false
                            viewModel.processedOrderId = nil
                        }
                    })
                }
                
                // Tombol "Bayar & Pesan Sekarang" di bagian bawah, di luar ScrollView
                VStack {
                    Spacer()
                    placeOrderButton()
                        .padding(.horizontal)
                        .padding(.bottom, 20) // Padding from bottom of screen
                }
                
                // Loading overlay
                if viewModel.paymentProcessing {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    ProgressView("Memproses Pesanan...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            } // End ZStack
        }
        .tint(.red) // Tint color for NavigationLink/Button
    }

    @ViewBuilder
    func cartHeader() -> some View {
        // CORRECTED: Use restaurantNameDisplay derived from itemName
        if !viewModel.activeCart.isEmpty {
            let restaurantNameDisplay = viewModel.activeCart.first?.itemName.lowercased().contains("nasi goreng") == true ? "Nasi Goreng 44" : (viewModel.activeCart.first != nil ? "Aneka Menu" : "Keranjang Belanja Anda")
            let restaurantImageDisplay = viewModel.activeCart.first?.itemName.lowercased().contains("nasi goreng") == true ? "nasi-goreng-44" : "foods"

            HStack(alignment: .bottom) {
                Image(restaurantImageDisplay) // Use the derived image name
                    .resizable().scaledToFill().frame(width: 70, height: 70).clipped().cornerRadius(15)
                Text(restaurantNameDisplay) // Use the derived restaurant name
                    .font(.title3).fontWeight(.semibold).padding(.leading, 10).padding(.bottom, 10)
                Spacer()
            }
            .background(Color("Beige")) // Same background as body
        } else {
            Text("Keranjang Belanja Anda")
                .font(.title2).fontWeight(.semibold)
                .foregroundColor(Color("DarkBrown")) // Consistent color
                .padding(.top, 10)
        }
    }
    
    @ViewBuilder
    func emptyCartView() -> some View {
        Spacer()
        Image(systemName: "cart.fill")
            .font(.system(size: 80)) // Larger icon size
            .foregroundColor(.gray.opacity(0.4)) // Softer
        Text("Keranjang Anda kosong.").font(.title3).foregroundColor(.gray).padding(.top, 10)
        Text("Yuk, mulai pilih makanan favoritmu!").font(.body).foregroundColor(.gray)
        Spacer()
    }

    @ViewBuilder
    func orderSummarySection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ringkasan Pesanan")
                .font(.headline)
                .foregroundColor(Color("DarkBrown")) // Consistent color

            VStack(spacing: 8) {
                summaryRowCart(label: "Subtotal Item", value: viewModel.currentCartSubtotalItems)
                summaryRowCart(label: "Ongkos Kirim", value: viewModel.shippingFee)
                if viewModel.discount > 0 {
                    summaryRowCart(label: "Diskon", value: -viewModel.discount, color: .green)
                }
                Divider() // Divider for total
                summaryRowCart(label: "Total Pembayaran", value: viewModel.currentCartTotalPayable, isTotal: true)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2) // Soft shadow
        }
    }
    
    @ViewBuilder
    func paymentMethodPicker() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Metode Pembayaran")
                .font(.headline)
                .foregroundColor(Color("DarkBrown")) // Consistent color

            Picker("Metode Pembayaran", selection: $selectedPaymentMethod) {
                ForEach(PaymentType.allCases) { method in
                    Text(method.rawValue).tag(method)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.white) // Picker background
            .cornerRadius(10) // Rounded corners for picker
            .clipped() // Ensure clipping if background/corner radius added

            if selectedPaymentMethod == .balance {
                HStack {
                    Text("Saldo Anda Saat Ini:")
                    Spacer()
                    if let userId = userSession.currentUserId {
                        Text("Rp\(String(format: "%.0f", DummyDataStore.shared.userBalances[userId] ?? 0.0))").fontWeight(.semibold)
                            .foregroundColor(Color("DarkBrown")) // Consistent color
                    } else { Text("N/A") }
                }
                .font(.footnote)
                .padding(.vertical, 5)
                .padding(.horizontal, 5) // Small padding to avoid crowding
                .background(Color.white.opacity(0.7)) // Balance background
                .cornerRadius(8)
            }
        }
    }

    @ViewBuilder
    func placeOrderButton() -> some View {
        Button(action: {
            viewModel.checkout(paymentMethod: selectedPaymentMethod)
        }) {
            Text("BAYAR & PESAN SEKARANG (Rp\(String(format: "%.0f", viewModel.currentCartTotalPayable)))")
                .font(.system(size: 16)).fontWeight(.bold).foregroundColor(.white)
                .padding(.vertical, 15) // Vertical padding
                .frame(maxWidth: .infinity)
                .background(viewModel.activeCart.isEmpty || viewModel.paymentProcessing ? Color.gray : Color.red)
                .cornerRadius(25)
                .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 5) // Consistent shadow
        }
        .disabled(viewModel.activeCart.isEmpty || viewModel.paymentProcessing)
    }

    func summaryRowCart(label: String, value: Double, isTotal: Bool = false, color: Color = .primary) -> some View {
        HStack {
            Text(label).foregroundColor(color)
            Spacer()
            Text("Rp\(String(format: "%.0f", value))").foregroundColor(color)
        }
        .font(isTotal ? .system(size: 16, weight: .bold) : .system(size: 14))
    }

    func deleteItemsFromVM(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { viewModel.activeCart[$0] }
        for item in itemsToDelete { viewModel.removeItemFromCart(itemId: item.id) }
    }
}
