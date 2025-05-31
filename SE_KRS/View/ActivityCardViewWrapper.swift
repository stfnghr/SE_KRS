// File: View/ActivityCardViewWrapper.swift
import SwiftUI

struct ActivityCardViewWrapper: View { //
    var order: Order // Menerima object Order

    var body: some View { //
        ZStack { //
            Rectangle() //
                .fill(Color.white) //
                .frame(maxWidth: .infinity) //
                .frame(height: 120) //
                .cornerRadius(20) //
                .shadow(radius: 3, x: 0, y: 3) //

            HStack(spacing: 15) { //
                Image(order.items.first?.itemName.lowercased().contains("nasi goreng") == true ? "nasi-goreng" : (order.items.first?.itemName.lowercased().contains("bubur") == true ? "bubur-ayam-ori" : (order.items.first?.itemName.lowercased().contains("kopi") == true ? "kopi-gula-aren" : "foods"))) //
                    .resizable() //
                    .scaledToFill() //
                    .frame(width: 90, height: 90) //
                    .clipped() //
                    .cornerRadius(15) //

                VStack(alignment: .leading, spacing: 4) { //
                    Text(order.restaurantName ?? order.items.first?.itemName ?? "Pesanan") //
                        .font(.system(size: 18, weight: .semibold)) //
                        .lineLimit(1) //
                    
                    Text("Order ID: \(order.id)") //
                        .font(.system(size: 12)) //
                        .foregroundColor(.gray) //

                    Text("Status: \(order.status.rawValue)") //
                        .font(.system(size: 13, weight: .medium)) //
                        .foregroundColor(statusColor(order.status)) //
                    
                    Text("Total: Rp\(String(format: "%.0f", order.totalAmount))") //
                        .font(.system(size: 14, weight: .semibold)) //
                        .foregroundColor(.red) //
                    
                    Text("Tanggal: \(order.timestampCreated, style: .date)") //
                        .font(.system(size: 12)) //
                        .foregroundColor(.orange) //
                }
                Spacer() //
            }
            .padding(.horizontal) //
        }
        .padding(.horizontal, 20) //
    }
    
    func statusColor(_ status: OrderStatus) -> Color { //
        switch status { //
        case .delivered: return .green //
        case .cancelled, .paymentFailed: return .red //
        case .processing, .paid, .outForDelivery: return .blue //
        default: return .gray //
        }
    }
}

#Preview("ActivityCardViewWrapperPreview") { //
    // <<< PERBAIKAN DI SINI >>>
    let orderItemPreview = OrderItem(
        itemId: "PREV001",
        itemName: "Nasi Goreng Mantap",
        quantity: 1,
        pricePerItem: 25000
        // Hapus subTotalItems: 25000 dari sini
    )
    
    let orderPreview = Order( //
        id: "ORDPREV00X", //
        userId: "userPreview", //
        items: [orderItemPreview], //
        totalAmount: 25000 + 5000, // Contoh totalAmount = subTotalItems + shippingFee - discount
        subTotalItems: 25000, //
        shippingFee: 5000,    // Contoh
        discount: 0,          // Contoh
        status: .processing, //
        timestampCreated: Date(), //
        timestampUpdated: Date(), //
        restaurantName: "Warung Makan Preview" //
    )
    ActivityCardViewWrapper(order: orderPreview) //
}
