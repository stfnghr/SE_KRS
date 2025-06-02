// File: View/OnProcessViewFromVM.swift
import MapKit
import SwiftUI

struct OnProcessViewFromVM: View {
    @ObservedObject var activityViewModel: ActivityViewModel  // Untuk update status
    var order: Order  // Terima Order object

    let location = CLLocationCoordinate2D(
        latitude: -7.2865722,
        longitude: 112.6320953
    )

    var body: some View {
        ZStack {
            Map {
                Marker("", coordinate: location)
            }
            .mapControlVisibility(.hidden)
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Order ID: \(order.id)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 30)

                        Text("Status: \(order.status.rawValue)")
                            .font(.headline)
                            .foregroundColor(statusColor(order.status))
                            .padding(.bottom)

                        // Courier Info (Contoh Statis)
                        Text("Your order is handled by,")  //
                            .font(.system(size: 14))  //
                        HStack {  //
                            Image(systemName: "person.circle.fill").resizable()
                                .frame(width: 50, height: 50).foregroundColor(
                                    .gray
                                ).padding(.trailing, 10)  //
                            VStack(alignment: .leading) {  //
                                Text(order.courierInfo ?? "Arif (Driver)")  // Gunakan data order jika ada
                                    .font(.system(size: 18, weight: .semibold))  //
                                Text("Honda Vario L1234BA")  // Data dummy
                                    .font(.system(size: 14)).foregroundColor(
                                        .orange)  //
                            }
                            Spacer()  //
                            HStack {
                                Image(systemName: "ellipsis.message")
                                Image(systemName: "phone")
                            }.foregroundColor(.red)  //
                        }.padding(.horizontal, 30)  //

                        // Delivery Details
                        Group {
                            detailRow(
                                title: "Pick Up Order at:",
                                value: order.restaurantName ?? "Nama Restoran")  //
                            detailRow(
                                title: "Delivered to:",
                                value: order.deliveryAddress ?? "Alamat Anda")  //
                        }.padding(.horizontal, 30)

                        Divider().background(.black).padding(.vertical)  //

                        // Order Items
                        VStack(alignment: .leading) {  //
                            Text("Order Details").font(.system(size: 14))
                                .foregroundColor(.orange)  //
                            ForEach(order.items) { item in
                                HStack {  //
                                    Text("\(item.itemName)").font(
                                        .system(size: 18))  //
                                    Spacer()  //
                                    Text("x\(item.quantity)").font(
                                        .system(size: 18))  //
                                }
                                .padding(.vertical, 1)
                            }
                            HStack {
                                Text("Total Amount:").font(
                                    .system(size: 18, weight: .semibold))
                                Spacer()
                                Text(
                                    "Rp\(String(format: "%.0f", order.totalAmount))"
                                ).font(.system(size: 18, weight: .semibold))
                            }
                            .padding(.top, 5)
                        }
                        .padding(.horizontal, 30)  //
                        .padding(.bottom, 20)

                        // Tombol untuk simulasi update status
                        actionButtons()

                        Spacer()
                    }
                    .padding(.top, 20)  // Padding di dalam ScrollView
                    .background(
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(30)
                            .shadow(radius: 2, x: 0, y: -2)
                    )
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
            }
        }
        .navigationTitle("Tracking Order")  // Judul lebih generik
        .navigationBarTitleDisplayMode(.inline)
        .tint(.black)  //
    }

    @ViewBuilder
    func detailRow(title: String, value: String) -> some View {
        HStack {  //
            VStack(alignment: .leading) {  //
                Text(title).font(.system(size: 14)).foregroundColor(.orange)  //
                Text(value).font(.system(size: 18))  //
            }
            .padding(.top, 10)  //
            Spacer()  //
        }
    }

    @ViewBuilder
    func actionButtons() -> some View {
        VStack {
            if order.status == .paid {
                Button("Simulate: Order Diproses Restoran") {
                    activityViewModel.updateOrderStatus(
                        orderId: order.id, newStatus: .processing)
                }
                .buttonStyle(.borderedProminent).tint(.orange)
            } else if order.status == .processing {
                Button("Simulate: Sedang Diantar Kurir") {
                    activityViewModel.updateOrderStatus(
                        orderId: order.id, newStatus: .outForDelivery)
                }
                .buttonStyle(.borderedProminent).tint(.blue)
            } else if order.status == .outForDelivery {
                Button("Simulate: Pesanan Tiba (Delivered)") {
                    activityViewModel.updateOrderStatus(
                        orderId: order.id, newStatus: .delivered)
                }
                .buttonStyle(.borderedProminent).tint(.green)
            }
        }
        .padding()
    }

    func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .paid: return .blue
        case .processing: return .purple
        case .outForDelivery: return .teal
        default: return .gray
        }
    }
}
