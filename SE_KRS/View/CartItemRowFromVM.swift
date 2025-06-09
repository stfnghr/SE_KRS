import SwiftUI

struct CartItemRowFromVM: View {
    @Binding var item: OrderModels
    @ObservedObject var cartViewModel: CartViewModel

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.headline)
                    .lineLimit(1)
                Text("Rp\(String(format: "%.0f", item.pricePerItem))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    if item.quantity > 1 {
                        cartViewModel.updateItemQuantityInCart(itemId: item.id, newQuantity: item.quantity - 1)
                    } else {
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
                    cartViewModel.updateItemQuantityInCart(itemId: item.id, newQuantity: item.quantity + 1)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
}
