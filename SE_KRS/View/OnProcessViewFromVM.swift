import SwiftUI

struct OnProcessViewFromVM: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var activityViewModel: ActivityViewModel
    let order: Order

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView
                driverInfoCard
                locationInfoCard
                orderDetailsCard
                completeOrderButton
                Spacer()
            }
            .padding()
        }
        .background(Color.lightBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Lacak Pesanan")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
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

    // MARK: - Subviews

    private var headerView: some View {
        VStack {
            Text("Status: \(order.status.rawValue)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(statusColor(order.status))
                .cornerRadius(20)
            
            Text("Order ID: \(order.id)")
                .font(.footnote)
                .foregroundColor(.secondaryText)
                .padding(.top, 4)
        }
    }
    
    private var driverInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Informasi Kurir")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.secondaryText)
                
                VStack(alignment: .leading) {
                    Text(order.courierInfo ?? "Arif (Driver)")
                        .fontWeight(.medium)
                    Text("Honda Vario L1234BA")
                        .font(.caption)
                        .foregroundColor(.secondaryText)
                }
                Spacer()
                HStack(spacing: 16) {
                    Image(systemName: "message.fill")
                    Image(systemName: "phone.fill")
                }
                .foregroundColor(.primaryRed)
                .font(.title3)
            }
        }
        .asCard()
    }

    private var locationInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Detail Pengiriman")
                .font(.headline)
                .fontWeight(.semibold)
            
            Divider()
            
            InfoRow(icon: "house.fill", label: "Diambil dari:", value: order.restaurantName ?? "Nama Restoran")
            InfoRow(icon: "mappin.and.ellipse", label: "Dikirim ke:", value: order.deliveryAddress ?? "Alamat Anda")
        }
        .asCard()
    }
    
    private var orderDetailsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rincian Pesanan")
                .font(.headline)
                .fontWeight(.semibold)
            
            Divider()
            
            ForEach(order.items) { item in
                HStack {
                    Text("\(item.quantity)x")
                        .foregroundColor(.secondaryText)
                    Text(item.itemName)
                    Spacer()
                    Text("Rp\(String(format: "%.0f", item.subtotal))")
                }
                .font(.subheadline)
            }
            
            Divider()
            
            HStack {
                Text("Total Pesanan")
                    .fontWeight(.bold)
                Spacer()
                Text("Rp\(String(format: "%.0f", order.totalAmount))")
                    .fontWeight(.bold)
                    .foregroundColor(.primaryRed)
            }
            .font(.headline)
        }
        .asCard()
    }

    @ViewBuilder
    private var completeOrderButton: some View {
        if order.status == .outForDelivery {
            Button(action: {
                activityViewModel.updateOrderStatus(orderId: order.id, newStatus: .delivered)
                dismiss()
            }) {
                Text("Pesanan Selesai")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                    .shadow(color: .green.opacity(0.3), radius: 5, y: 3)
            }
            .padding(.top, 10)
        }
    }

    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .processing, .paid: return .blue
        case .outForDelivery: return .orange
        case .delivered: return .green
        default: return .gray
        }
    }
}

private struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondaryText)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.primaryRed)
                Text(value)
                    .fontWeight(.medium)
            }
            .font(.subheadline)
        }
    }
}

struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
}

extension View {
    func asCard() -> some View {
        self.modifier(CardViewModifier())
    }
}
