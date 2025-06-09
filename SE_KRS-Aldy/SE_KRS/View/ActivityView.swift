// File: View/ActivityView.swift (REVISED)
import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var viewModel: ActivityViewModel
    
    // State untuk picker
    @State private var selectedIndex = 0
    private let options = ["Dalam Proses", "Riwayat"]

    init(userSession: UserSession) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(userSession: userSession))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Latar belakang yang konsisten
                Color(red: 245/255, green: 245/255, blue: 245/255).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("Aktivitas Anda")
                        .font(.title2).bold()
                        .padding()
                    
                    Picker("Pilih Tipe Aktivitas", selection: $selectedIndex) {
                        ForEach(0..<options.count, id: \.self) { index in
                            Text(options[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                    
                    if viewModel.isLoading {
                        ProgressView("Memuat aktivitas...")
                        Spacer()
                    } else if !userSession.isLoggedIn {
                        // Tampilan jika pengguna belum login
                        activityEmptyView(
                            icon: "person.crop.circle.badge.xmark",
                            title: "Anda Belum Login",
                            message: "Silakan login terlebih dahulu untuk melihat aktivitas pesanan Anda."
                        )
                    } else {
                        // Tampilan berdasarkan pilihan picker
                        contentForSelectedIndex
                    }
                }
            }
        }
        .onAppear {
            if userSession.isLoggedIn {
                viewModel.fetchAllUserOrders()
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var contentForSelectedIndex: some View {
        if selectedIndex == 0 { // Dalam Proses
            if viewModel.onProcessOrders.isEmpty {
                activityEmptyView(
                    icon: "shippingbox.fill",
                    title: "Tidak Ada Pesanan",
                    message: "Saat ini tidak ada pesanan yang sedang diproses."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.onProcessOrders) { order in
                            NavigationLink(destination: OnProcessViewFromVM(activityViewModel: viewModel, order: order)) {
                                ActivityCardViewWrapper(order: order)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
            }
        } else { // Riwayat
            if viewModel.historicalOrders.isEmpty {
                activityEmptyView(
                    icon: "doc.text.magnifyingglass",
                    title: "Riwayat Kosong",
                    message: "Anda belum pernah menyelesaikan pesanan apapun."
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.historicalOrders) { order in
                             NavigationLink(destination: HistoryOrderViewFromVM(order: order)) {
                                ActivityCardViewWrapper(order: order)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
    
    // View untuk tampilan saat halaman kosong
    private func activityEmptyView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
            Spacer()
        }
    }
}
