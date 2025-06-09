import SwiftUI

struct CartItemRowFromVM: View {
    @Binding var item: OrderModels // Menggunakan @Binding untuk quantity
    @ObservedObject var cartViewModel: CartViewModel // Untuk memanggil fungsi update

    var body: some View {
        HStack(spacing: 12) {
            // Anda bisa menambahkan gambar di sini jika ada
            // Image("nama_gambar_item")
            //     .resizable().frame(width: 60, height: 60).cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.headline)
                    .lineLimit(1)
                Text("Rp\(String(format: "%.0f", item.pricePerItem))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // --- INI BAGIAN LOGIKA PLUS MINUS ---
            HStack(spacing: 12) {
                Button(action: {
                    // Jika kuantitas lebih dari 1, kurangi 1.
                    if item.quantity > 1 {
                        cartViewModel.updateItemQuantityInCart(itemId: item.id, newQuantity: item.quantity - 1)
                    } else {
                        // Jika kuantitas sisa 1, hapus item dari keranjang.
                        cartViewModel.removeItemFromCart(itemId: item.id)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                
                Text("\(item.quantity)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(minWidth: 25)
                
                Button(action: {
                    // Tambah kuantitas sebanyak 1.
                    cartViewModel.updateItemQuantityInCart(itemId: item.id, newQuantity: item.quantity + 1)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .buttonStyle(BorderlessButtonStyle()) // Agar tombol bisa diklik di dalam list
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
}
