// File: View/ActivityCardViewWrapper.swift (REVISED)
import SwiftUI

struct ActivityCardViewWrapper: View {
    var order: Order

    var body: some View {
        HStack(spacing: 15) {
            // Gambar Item
            Image(order.items.first?.itemName.lowercased().contains("nasi goreng") == true ? "nasi-goreng" : (order.items.first?.itemName.lowercased().contains("bubur") == true ? "bubur-ayam-ori" : (order.items.first?.itemName.lowercased().contains("kopi") == true ? "kopi-gula-aren" : "foods")))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                .clipped()

            // Detail Pesanan
            VStack(alignment: .leading, spacing: 6) {
                Text(order.restaurantName ?? "Pesanan")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                // Status dengan warna
                Text(order.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(order.status))
                    .cornerRadius(15)

                // Detail Harga dan Tanggal
                HStack {
                    Text("Total: Rp\(String(format: "%.0f", order.totalAmount))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                    Spacer()
                    Text(order.timestampCreated, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Indikator panah untuk navigasi
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
        .padding(.horizontal)
    }
    
    // Fungsi untuk memberi warna pada status
    func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .delivered: return .green
        case .cancelled, .paymentFailed: return .red
        case .processing, .paid: return .blue
        case .outForDelivery: return .orange
        default: return .gray
        }
    }
}
