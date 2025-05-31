// File: View/ProfileView.swift
import SwiftUI

struct ProfileView: View { //
    @EnvironmentObject var userSession: UserSession // Untuk info user dan logout
    @StateObject private var viewModel: ProfileViewModel
    
    @State private var topUpAmountString: String = ""

    init(userSession: UserSession) { // Terima UserSession untuk inisialisasi ViewModel
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userSession: userSession))
    }

    var body: some View { //
        NavigationView {
            ZStack { //
                Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255) //
                    .ignoresSafeArea(.all) //

                Rectangle() //
                    .fill(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)) //
                    .cornerRadius(30) //
                    .padding(.top, 200) //
                    .ignoresSafeArea(.all) //

                ScrollView {
                    VStack(spacing: 20) {
                        profileHeader()
                        balanceSectionFromViewModel()
                        topUpSectionFromViewModel()
                        Spacer()
                        logoutButton()
                    }
                    .padding(.top, 60)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Info"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear { // Penting untuk memuat saldo saat view muncul atau user berubah
                viewModel.fetchBalance()
            }
        }
    }

    // profileHeader dan logoutButton menggunakan @EnvironmentObject userSession
    @ViewBuilder
    func profileHeader() -> some View { //
        // ... (Konten sama seperti sebelumnya, menggunakan userSession.loggedInUser)
        VStack { //
            Circle() //
                .fill(.white) //
                .frame(width: 110, height: 110) //
                .overlay(
                    Image(systemName: "person.fill")
                        .resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
                )
                .padding(.bottom, -55).zIndex(1) //

            VStack(alignment: .center) { //
                Text(userSession.loggedInUser?.name ?? "Guest User").font(.title).fontWeight(.bold).foregroundColor(Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255)) //
                Text(userSession.loggedInUser?.phone ?? "+62 000-0000-0000").font(.subheadline) //
                Text(userSession.loggedInUser?.email ?? "guest@example.com").font(.subheadline).foregroundColor(.black).padding(.bottom, 5) //
            }
            .frame(maxWidth: .infinity).padding(.top, 70).padding(.horizontal, 40) //
        }
    }

    @ViewBuilder
    func balanceSectionFromViewModel() -> some View {
        // ... (Konten sama seperti sebelumnya, menggunakan viewModel.userBalance)
        VStack(alignment: .leading, spacing: 10) {
            Text("My Balance").font(.headline)
            HStack {
                Image(systemName: "creditcard.fill").foregroundColor(.orange)
                Text("Rp \(String(format: "%.0f", viewModel.userBalance))").font(.title2).fontWeight(.semibold)
                Spacer()
            }
        }.padding().background(Color.white).cornerRadius(10).shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2).padding(.horizontal)
    }

    @ViewBuilder
    func topUpSectionFromViewModel() -> some View {
        // ... (Konten sama seperti sebelumnya, memanggil viewModel.topUpBalance)
        VStack(alignment: .leading, spacing: 10) {
            Text("Top Up Balance").font(.headline)
            HStack {
                TextField("Enter amount", text: $topUpAmountString).keyboardType(.numberPad).padding(8).background(Color.gray.opacity(0.1)).cornerRadius(5)
                Button(action: {
                    guard let amount = Double(topUpAmountString), amount > 0 else {
                        viewModel.alertMessage = "Please enter a valid positive amount."
                        viewModel.showAlert = true
                        return
                    }
                    viewModel.topUpBalance(amount: amount)
                    topUpAmountString = ""
                }) {
                    Text("Top Up").fontWeight(.semibold).foregroundColor(.white).padding(.horizontal, 15).padding(.vertical, 8).background(Color.green).cornerRadius(25)
                }
            }
        }.padding().background(Color.white).cornerRadius(10).shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2).padding(.horizontal)
    }
    
    @ViewBuilder
    func logoutButton() -> some View { //
        // ... (Konten sama seperti sebelumnya, memanggil userSession.logoutUser)
        Button(action: { userSession.logoutUser() }) { //
            Text("LOG OUT").fontWeight(.bold).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.red.opacity(0.8)).cornerRadius(25) //
        }.padding(.horizontal).padding(.bottom, 20)
    }
}

// Preview untuk ProfileView
#Preview("ProfileView With ViewModel") {
    let previewUserSession = UserSession()
    let dummyUser = UserModel(name: "Profile Preview", phone: "08123", email: "profile@preview.com", password: "123", balance: 50000)
    // Pastikan data saldo ada di DummyDataStore untuk preview
    DummyDataStore.shared.userBalances[dummyUser.id.uuidString] = dummyUser.balance
    previewUserSession.loginUser(user: dummyUser)

    return ProfileView(userSession: previewUserSession)
        .environmentObject(previewUserSession) // Jika sub-komponen masih membutuhkannya via env
}
