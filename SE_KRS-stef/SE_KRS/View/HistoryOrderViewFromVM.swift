// File: View/HistoryOrderViewFromVM.swift
import SwiftUI

struct HistoryOrderViewFromVM: View {
    var order: Order  // Terima Order object

    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)  //
                .ignoresSafeArea(.all)

            ScrollView {
                VStack {
                    Rectangle()  //
                        .fill(.white)  //
                        .frame(maxWidth: .infinity)
                        .frame(height: 500)
                        .cornerRadius(20)  //
                        .shadow(radius: 3, x: 0, y: 3)  //
                        .overlay(
                            VStack(alignment: .leading, spacing: 10) {  //
                                Text(
                                    order.restaurantName
                                        ?? "Pesanan \(order.id)"
                                )  //
                                .font(.title2).fontWeight(.bold).padding(
                                    .top, 20)  //

                                Text("Order ID: \(order.id)")
                                    .font(.caption).foregroundColor(.gray)

                                Text(
                                    "Tanggal: \(order.timestampCreated, style: .date) pukul \(order.timestampCreated, style: .time)"
                                )  //
                                .font(.system(size: 14)).foregroundColor(
                                    .orange)  //

                                Text("Status: \(order.status.rawValue)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(
                                        statusColorReceipt(order.status)
                                    )
                                    .padding(.bottom, 10)  //

                                Text("Item Dipesan:").font(.headline)
                                ForEach(order.items) { item in
                                    HStack {  //
                                        Text(item.itemName).font(
                                            .system(size: 14))  //
                                        Spacer()  //
                                        Text("x\(item.quantity)").font(
                                            .system(size: 14))  //
                                    }.padding(.horizontal).padding(.vertical, 1)  //
                                }

                                Divider().background(.black).padding()  //

                                receiptSummaryRow(
                                    label: "Harga",
                                    value: order.items.reduce(0) {
                                        $0 + $1.subtotal
                                    })  //
                                receiptSummaryRow(label: "Ongkir", value: 10000)  // Dummy ongkir
                                // receiptSummaryRow(label: "Diskon", value: -20000) //
                                receiptSummaryRow(
                                    label: "Total Pembayaran",
                                    value: order.totalAmount + 10000,
                                    isTotal: true)  // Asumsi totalAmount adalah subtotal barang

                                HStack {  //
                                    Text("Metode Pembayaran").font(
                                        .system(size: 14))  //
                                    Spacer()  //
                                    Text("Saldo Aplikasi").font(
                                        .system(size: 14))  // Asumsi
                                }.padding(.horizontal).padding(.vertical, 2)  //

                                Spacer()  //

                                if order.status == .delivered {  // Tampilkan info kurir jika sudah delivered
                                    Text("Informasi Kurir").font(.subheadline)
                                        .padding(.top)  //
                                    HStack {  //
                                        Image(
                                            systemName:
                                                "person.crop.circle.fill"
                                        ).resizable().frame(
                                            width: 30, height: 30
                                        ).foregroundColor(.gray)  //
                                        VStack(alignment: .leading) {  //
                                            Text(order.courierInfo ?? "Arif")
                                                .font(.system(size: 14))  //
                                            Text("Honda Vario L1234BA").font(
                                                .system(size: 12)
                                            ).foregroundColor(.gray)  //
                                        }
                                        Spacer()  //
                                        VStack {
                                            Image(systemName: "star.fill")
                                                .resizable().frame(
                                                    width: 15, height: 15
                                                ).foregroundColor(.yellow)
                                            Text("5").font(.caption)
                                        }.padding(.leading, 50)  // Disesuaikan //
                                    }.padding(.horizontal)
                                }
                                // Button("DOWNLOAD RECEIPT") { ... } .padding(.top) (Tombol download jika perlu)
                            }
                            .padding(.horizontal, 20)  // Padding untuk konten di dalam overlay
                            .padding(.vertical, 30)  //
                        ).padding(20)  // Padding untuk kartu putih
                }  // End VStack utama
            }  // End ScrollView
        }
        .navigationTitle("Receipt")  // Judul diubah
        .navigationBarTitleDisplayMode(.inline)
    }

    func receiptSummaryRow(label: String, value: Double, isTotal: Bool = false)
        -> some View
    {
        HStack {  //
            Text(label).font(
                isTotal ? .system(size: 14, weight: .bold) : .system(size: 14))  //
            Spacer()  //
            Text("Rp\(String(format: "%.0f", value))").font(
                isTotal ? .system(size: 14, weight: .bold) : .system(size: 14))  //
        }.padding(.horizontal).padding(.vertical, 2)  //
    }

    func statusColorReceipt(_ status: OrderStatus) -> Color {
        switch status {
        case .delivered: return .green
        case .cancelled: return .red
        case .paymentFailed: return .orange
        default: return .gray  // Status lain tidak umum di history receipt, tapi sebagai fallback
        }
    }
}
