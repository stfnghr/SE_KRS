// File: View/ActivityView.swift
import SwiftUI

struct ActivityView: View { //
    @EnvironmentObject var userSession: UserSession // Untuk diteruskan ke ViewModel
    @StateObject private var viewModel: ActivityViewModel
    
    @State private var selectedIndex = 0 //
    let options = ["On Process", "History"] //

    init(userSession: UserSession) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(userSession: userSession))
    }

    var body: some View { //
        NavigationStack {
            ZStack { //
                Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255) //
                    .ignoresSafeArea(.all)
                
                VStack { //
                    Text("Your Activity") //
                        .font(.title).fontWeight(.bold).padding()
                    
                    Picker("", selection: $selectedIndex) { //
                        ForEach(0..<options.count, id: \.self) { Text(options[$0]) }
                    }
                    .pickerStyle(SegmentedPickerStyle()).padding() //
                    
                    if viewModel.isLoading {
                        ProgressView("Loading activities...")
                        Spacer()
                    } else if !userSession.isLoggedIn {
                        Text("Please log in to see your activity.").foregroundColor(.gray)
                        Spacer()
                    } else {
                        contentForSelectedIndexFromVM()
                    }
                }
            }
        }
        .tint(.orange) //
        .onAppear {
            if userSession.isLoggedIn {
                viewModel.fetchAllUserOrders()
            }
        }
    }
    
    @ViewBuilder
    func contentForSelectedIndexFromVM() -> some View {
        if selectedIndex == 0 { // On Process
            if viewModel.onProcessOrders.isEmpty {
                Text("No orders currently in process.").foregroundColor(.gray).padding()
            } else {
                ScrollView { //
                    VStack(spacing: 16) { //
                        ForEach(viewModel.onProcessOrders) { order in
                            NavigationLink(destination: OnProcessViewFromVM(activityViewModel: viewModel, order: order)) { //
                                ActivityCardViewWrapper(order: order)
                            }
                            .buttonStyle(PlainButtonStyle()) //
                        }
                    }
                    .padding(.vertical)
                }
            }
        } else { // History
            if viewModel.historicalOrders.isEmpty {
                Text("No order history found.").foregroundColor(.gray).padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
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
}

