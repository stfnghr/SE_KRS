import SwiftUI

struct CartItemRowFromVM: View {
    @Binding var item: OrderModels // Menggunakan @Binding untuk quantity
    @ObservedObject var cartViewModel: CartViewModel // Untuk memanggil fungsi update

    var body: some View {
        HStack {
            // Anda bisa menambahkan gambar item di sini jika ada info gambar di OrderItem
            // Contoh:
            // Image(item.imageName) // Asumsi OrderItem punya imageName
            //     .resizable()
            //     .scaledToFit()
            //     .frame(width: 50, height: 50)
            //     .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(item.itemName)
                    .font(.headline)
                Text("Rp\(String(format: "%.0f", item.pricePerItem)) / item")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    if item.quantity > 1 {
                        cartViewModel.updateItemQuantityInCart(itemId: item.id, newQuantity: item.quantity - 1)
                    } else {
                        cartViewModel.removeItemFromCart(itemId: item.id)
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Text("\(item.quantity)")
                    .font(.headline)
                    .frame(minWidth: 25, alignment: .center)
                
                Button {
                     cartViewModel.updateItemQuantityInCart(itemId: item.id, newQuantity: item.quantity + 1)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal, 5)
            
            Text("Rp\(String(format: "%.0f", item.subtotal))")
                .font(.headline)
                .frame(width: 80, alignment: .trailing)
        }
        .padding(.vertical, 4)
    }
}
