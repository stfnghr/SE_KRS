// File: View/HistoryOrderViewFromVM.swift (REVISED)
import SwiftUI

struct HistoryOrderViewFromVM: View {
    @Environment(\.dismiss) var dismiss
    var order: Order

    var body: some View {
        ZStack {
            // Menggunakan warna background yang konsisten
            Color.lightBackground.ignoresSafeArea()
            
            ScrollView {
                // Menggunakan VStack untuk menampung beberapa kartu
                VStack(spacing: 16) {
                    orderSummaryCard
                    itemDetailsCard
                    paymentDetailsCard
                    
                    // Kartu informasi kurir hanya muncul jika pesanan sudah selesai
                    if order.status == .delivered {
                        courierInfoCard
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Receipt")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Menambahkan tombol back custom agar seragam
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.secondaryText.opacity(0.5))
                }
            }
        }
    }

    // MARK: - Subviews for Cards

    @ViewBuilder
    private var orderSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "building.2.crop.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                VStack(alignment: .leading) {
                    Text(order.restaurantName ?? "Pesanan")
                        .font(.headline).fontWeight(.semibold)
                    Text("Order ID: \(order.id)")
                        .font(.caption).foregroundColor(.secondaryText)
                }
            }
            Divider()
            InfoRow(label: "Tanggal Pesanan", value: order.timestampCreated.formatted(date: .long, time: .shortened))
            InfoRow(label: "Status", value: order.status.rawValue, valueColor: statusColorReceipt(order.status))
        }
        .asCard()
    }
    
    @ViewBuilder
    private var itemDetailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Item Dipesan").font(.headline).fontWeight(.semibold)
            Divider()
            ForEach(order.items) { item in
                HStack {
                    Text("\(item.quantity)x")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                    Text(item.itemName)
                        .font(.subheadline)
                    Spacer()
                    Text("Rp\(String(format: "%.0f", item.subtotal))")
                        .font(.subheadline)
                }
            }
        }
        .asCard()
    }
    
    @ViewBuilder
    private var paymentDetailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rincian Pembayaran").font(.headline).fontWeight(.semibold)
            Divider()
            PaymentRow(label: "Subtotal Item", amount: order.subTotalItems)
            PaymentRow(label: "Ongkos Kirim", amount: order.shippingFee)
            if order.discount > 0 {
                PaymentRow(label: "Diskon", amount: -order.discount, color: .green)
            }
            Divider()
            HStack {
                Text("Total Pembayaran").font(.headline).fontWeight(.bold)
                Spacer()
                Text("Rp\(String(format: "%.0f", order.totalAmount))")
                    .font(.headline).fontWeight(.bold)
            }
            Divider()
            InfoRow(label: "Metode Pembayaran", value: order.paymentMethodUsed?.rawValue ?? "N/A")
        }
        .asCard()
    }
    
    @ViewBuilder
    private var courierInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Informasi Kurir").font(.headline).fontWeight(.semibold)
            Divider()
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.secondaryText)
                VStack(alignment: .leading) {
                    Text(order.courierInfo ?? "Arif").fontWeight(.medium)
                    Text("Honda Vario L1234BA").font(.caption).foregroundColor(.secondaryText)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("5.0").font(.subheadline) // Rating dummy
                }
            }
        }
        .asCard()
    }
    
    // MARK: - Helper Functions & Views

    private func statusColorReceipt(_ status: OrderStatus) -> Color {
        switch status {
        case .delivered: return .green
        case .cancelled: return .red
        case .paymentFailed: return .orange
        default: return .gray
        }
    }
    
    private struct InfoRow: View {
        let label: String
        let value: String
        var valueColor: Color = .primary
        
        var body: some View {
            HStack {
                Text(label).font(.subheadline).foregroundColor(.secondaryText)
                Spacer()
                Text(value).font(.subheadline).fontWeight(.semibold).foregroundColor(valueColor)
            }
        }
    }
    
    private struct PaymentRow: View {
        let label: String
        let amount: Double
        var color: Color = .primary
        
        var body: some View {
            HStack {
                Text(label).font(.subheadline)
                Spacer()
                Text("Rp\(String(format: "%.0f", amount))")
                    .font(.subheadline)
                    .foregroundColor(color)
            }
        }
    }
}
