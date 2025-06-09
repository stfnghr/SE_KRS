// File: View/CartView.swift (REVISED)
import SwiftUI

struct CartView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var viewModel: CartViewModel
    
    // State untuk metode pembayaran yang dipilih
    @State private var selectedPaymentMethod: PaymentType = .balance

    var body: some View {
        NavigationStack {
            ZStack {
                // Latar belakang yang konsisten
                Color(red: 245/255, green: 245/255, blue: 245/255).ignoresSafeArea()
                
                if viewModel.activeCart.isEmpty {
                    emptyCartView
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 18) {
                            // PERUBAHAN: Header dibuat lebih bersih
                            cartHeader.padding(.horizontal)
                            
                            // Daftar Item
                            ForEach($viewModel.activeCart) { $item in
                                CartItemRowFromVM(item: $item, cartViewModel: viewModel)
                                    .padding(.horizontal)
                            }
                            
                            // PERUBAHAN: Ringkasan pesanan dalam bentuk kartu
                            orderSummaryCard.padding()
                            
                            // PERUBAHAN: Pilihan metode pembayaran dalam bentuk kartu
                            paymentMethodCard.padding(.horizontal)
                            
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 90) // Beri ruang untuk tombol di bawah
                }
                
                // Tombol Bayar menempel di bawah
                VStack {
                    Spacer()
                    placeOrderButton
                        .padding(.horizontal, 24)
                        .padding(.bottom, 10)
                }
                
                // Overlay saat pembayaran diproses
                if viewModel.paymentProcessing {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    ProgressView("Memproses Pesanan...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            .navigationTitle("Keranjang")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertTitle),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")) {
                    if viewModel.orderProcessedSuccessfully {
                        viewModel.orderProcessedSuccessfully = false
                        viewModel.processedOrderId = nil
                    }
                })
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var cartHeader: some View {
        if let firstItem = viewModel.activeCart.first {
            // Logika untuk menampilkan nama restoran dari item pertama (bisa disesuaikan)
            let restaurantName = firstItem.itemName.contains("Mie Goreng") ? "Nasi Goreng 44" : "Aneka Menu"
            let restaurantImage = firstItem.itemName.contains("Mie Goreng") ? "nasi-goreng-44" : "foods"

            HStack {
                Image(restaurantImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                Text(restaurantName)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
        }
    }

    private var emptyCartView: some View {
        VStack {
            Image(systemName: "cart.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("Keranjang Anda kosong")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 8)
            Text("Yuk, tambahkan makanan favoritmu!")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    private var orderSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ringkasan Pesanan")
                .font(.headline)
                .fontWeight(.semibold)
            
            summaryRow(label: "Subtotal Item", value: viewModel.currentCartSubtotalItems)
            summaryRow(label: "Ongkos Kirim", value: viewModel.shippingFee)
            if viewModel.discount > 0 {
                summaryRow(label: "Diskon", value: -viewModel.discount, color: .green)
            }
            
            Divider().padding(.vertical, 4)
            
            HStack {
                Text("Total Pembayaran")
                    .fontWeight(.bold)
                Spacer()
                Text("Rp. \(String(format: "%.0f", viewModel.currentCartTotalPayable))")
                    .fontWeight(.bold)
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
    
    private var paymentMethodCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metode Pembayaran")
                .font(.headline)
                .fontWeight(.semibold)
            
            Picker("Metode Pembayaran", selection: $selectedPaymentMethod) {
                ForEach(PaymentType.allCases) { method in
                    Text(method.rawValue).tag(method)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            if selectedPaymentMethod == .balance {
                HStack {
                    Text("Saldo Anda Saat Ini:")
                    Spacer()
                    if let userId = userSession.currentUserId, let balance = DummyDataStore.shared.userBalances[userId] {
                        Text("Rp. \(String(format: "%.0f", balance))")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    } else {
                        Text("Rp. 0").foregroundColor(.gray)
                    }
                }
                .font(.footnote)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
    
    private var placeOrderButton: some View {
        Button(action: {
            // Pilih restoran pertama di keranjang sebagai referensi order
            let restaurantForOrder = viewModel.activeCart.isEmpty ? nil : RestaurantModel(name: "Aneka Menu", address: "", rating: 0, image: "")
            viewModel.checkout(paymentMethod: selectedPaymentMethod, restaurantForOrder: restaurantForOrder)
        }) {
            Text("BAYAR & PESAN SEKARANG (Rp\(String(format: "%.0f", viewModel.currentCartTotalPayable)))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.activeCart.isEmpty || viewModel.paymentProcessing ? Color.gray : Color.red)
                .cornerRadius(15)
        }
        .disabled(viewModel.activeCart.isEmpty || viewModel.paymentProcessing)
    }

    private func summaryRow(label: String, value: Double, color: Color = .primary) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text("Rp\(String(format: "%.0f", value))")
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .font(.subheadline)
    }
}
