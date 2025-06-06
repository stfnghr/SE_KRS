// File: View/CartView.swift
import SwiftUI

struct CartView: View {
    @EnvironmentObject var userSession: UserSession // Masih bisa berguna untuk info user
    // <<< GUNAKAN @EnvironmentObject untuk viewModel, BUKAN @StateObject >>>
    @EnvironmentObject var viewModel: CartViewModel
    
    // State untuk pilihan metode pembayaran tetap di sini
    @State private var selectedPaymentMethod: PaymentType = .balance

    // <<< HAPUS init(userSession: UserSession) >>>
    // init(userSession: UserSession) {
    //     // _viewModel = StateObject(wrappedValue: CartViewModel(userSession: userSession)) // JANGAN BUAT INSTANCE BARU DI SINI
    // }
    
    var body: some View {
        NavigationStack {
            ZStack { // Tambahkan ZStack untuk overlay loading
                VStack {
                    cartHeader() // Menggunakan viewModel dari environment
                    Divider().background(.black).padding(.horizontal)

                    // Logika if/else menggunakan viewModel dari environment
                    if viewModel.activeCart.isEmpty && !viewModel.paymentProcessing {
                        emptyCartView()
                    } else {
                        cartContentList() // Menggunakan viewModel dari environment
                        if !viewModel.activeCart.isEmpty {
                            paymentMethodPicker() // Menggunakan viewModel dari environment
                        }
                        placeOrderButton() // Menggunakan viewModel dari environment
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .navigationTitle("Keranjang")
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: $viewModel.showAlert) { // Menggunakan viewModel dari environment
                    Alert(title: Text(viewModel.alertTitle),
                          message: Text(viewModel.alertMessage),
                          dismissButton: .default(Text("OK")) {
                        if viewModel.orderProcessedSuccessfully {
                            viewModel.orderProcessedSuccessfully = false
                            viewModel.processedOrderId = nil
                        }
                    })
                }
                
                if viewModel.paymentProcessing { // Menggunakan viewModel dari environment
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    ProgressView("Memproses Pesanan...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            } // End ZStack
        }
        .tint(.orange)
        // .onAppear {
        //    // Jika perlu melakukan sesuatu saat CartView muncul dengan viewModel dari environment
        //    // print("CartView appeared. Cart items: \(viewModel.activeCart.count)")
        // }
    }

    @ViewBuilder
    func cartHeader() -> some View { //
        let restaurantNameDisplay = viewModel.activeCart.first?.itemName.contains("Nasi Goreng") == true ? "Nasi Goreng 44" : (viewModel.activeCart.first != nil ? "Aneka Menu" : "Keranjang Belanja") //
        let restaurantImageDisplay = viewModel.activeCart.first?.itemName.contains("Nasi Goreng") == true ? "nasi-goreng-44" : "foods" //

        if !viewModel.activeCart.isEmpty { //
            HStack (alignment: .bottom) { //
                Image(restaurantImageDisplay).resizable().scaledToFill().frame(width: 70, height: 70).clipped().cornerRadius(15) //
                Text(restaurantNameDisplay).font(.title3).fontWeight(.semibold).padding(.leading, 10).padding(.bottom, 10) //
                Spacer() //
            }.padding(.top, 10) //
        } else {
            Text("Keranjang Belanja").font(.title2).fontWeight(.semibold).padding(.top, 10) //
        }
    }
    
    @ViewBuilder
    func emptyCartView() -> some View { //
        Spacer() //
        Image(systemName: "cart.fill").font(.system(size: 60)).foregroundColor(.gray.opacity(0.5)) //
        Text("Keranjang Anda kosong.").font(.headline).foregroundColor(.gray).padding(.top) //
        Text("Yuk, mulai pilih makanan favoritmu!").font(.subheadline).foregroundColor(.gray) //
        Spacer() //
    }

    @ViewBuilder
    func cartContentList() -> some View { //
        List {
            ForEach($viewModel.activeCart) { $itemInCart in //
                CartItemRowFromVM(item: $itemInCart, cartViewModel: viewModel)
            }
            .onDelete(perform: deleteItemsFromVM) //
            
            Section(header: Text("Ringkasan Pesanan").font(.headline)) { //
                summaryRowCart(label: "Subtotal Item", value: viewModel.currentCartSubtotalItems) //
                summaryRowCart(label: "Ongkos Kirim", value: viewModel.shippingFee) //
                if viewModel.discount > 0 { //
                    summaryRowCart(label: "Diskon", value: -viewModel.discount, color: .green) //
                }
                summaryRowCart(label: "Total Pembayaran", value: viewModel.currentCartTotalPayable, isTotal: true) //
            }
        }
        .listStyle(GroupedListStyle()) //
        .frame(maxHeight: UIScreen.main.bounds.height * 0.45) // Sesuaikan maxHeight agar ada ruang untuk Picker dan Button
    }
    
    @ViewBuilder
    func paymentMethodPicker() -> some View { //
        VStack(alignment: .leading) { //
            Text("Metode Pembayaran").font(.headline).padding(.top) //
            Picker("Metode Pembayaran", selection: $selectedPaymentMethod) { //
                ForEach(PaymentType.allCases) { method in //
                    Text(method.rawValue).tag(method) //
                }
            }
            .pickerStyle(SegmentedPickerStyle()) //
            
            if selectedPaymentMethod == .balance { //
                HStack { //
                    Text("Saldo Anda Saat Ini:") //
                    Spacer() //
                    if let userId = userSession.currentUserId { //
                         Text("Rp\(String(format: "%.0f", DummyDataStore.shared.userBalances[userId] ?? 0.0))").fontWeight(.semibold) //
                     } else { Text("N/A") } //
                }.font(.footnote).padding(.vertical, 5) //
            }
        }.padding(.vertical, 10) //
    }

    @ViewBuilder
    func placeOrderButton() -> some View { //
        Button(action: { //
            viewModel.checkout(paymentMethod: selectedPaymentMethod) //
        }) {
            Text("BAYAR & PESAN SEKARANG (Rp\(String(format: "%.0f", viewModel.currentCartTotalPayable)))") //
                .font(.system(size: 14)).fontWeight(.bold).foregroundColor(.white) //
                .padding().frame(height: 50).frame(maxWidth: .infinity) //
                .background(viewModel.activeCart.isEmpty || viewModel.paymentProcessing ? Color.gray : Color.red) //
                .cornerRadius(25) //
        }
        .padding(.vertical) //
        .disabled(viewModel.activeCart.isEmpty || viewModel.paymentProcessing) //
    }

    func summaryRowCart(label: String, value: Double, isTotal: Bool = false, color: Color = .primary) -> some View { //
        HStack { Text(label).foregroundColor(color); Spacer(); Text("Rp\(String(format: "%.0f", value))").foregroundColor(color) } //
        .font(isTotal ? .system(size: 16, weight: .bold) : .system(size: 14)) //
    }

    func deleteItemsFromVM(at offsets: IndexSet) { //
        let itemsToDelete = offsets.map { viewModel.activeCart[$0] } //
        for item in itemsToDelete { viewModel.removeItemFromCart(itemId: item.id) } //
    }
}

// Pastikan CartItemRowFromVM sudah didefinisikan di proyek Anda
// struct CartItemRowFromVM: View { ... }


