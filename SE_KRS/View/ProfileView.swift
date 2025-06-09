// File: View/ProfileView.swift (REVISED)
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var viewModel: ProfileViewModel
    
    @State private var topUpAmountString: String = ""

    init(userSession: UserSession) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userSession: userSession))
    }

    var body: some View {
        NavigationView {
            // PERUBAHAN: Menggunakan ZStack hanya untuk latar belakang yang sederhana
            ZStack {
                Color.lightBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // PERUBAHAN: Semua elemen UI di dalam VStack utama
                        profileHeaderCard
                        
                        balanceCard
                        
                        topUpCard
                        
                        Spacer(minLength: 30)
                        
                        logoutButton
                    }
                    .padding()
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Info"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                viewModel.fetchBalance()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeaderCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.secondaryText.opacity(0.5))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userSession.loggedInUser?.name ?? "Nama Pengguna")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(userSession.loggedInUser?.email ?? "email@pengguna.com")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Saldo Saya")
                .font(.headline)
                .foregroundColor(.secondaryText)
            
            HStack {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.primaryRed)
                Text("Rp \(String(format: "%.0f", viewModel.userBalance))")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }

    private var topUpCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Isi Ulang Saldo")
                .font(.headline)
            
            HStack(spacing: 10) {
                TextField("Masukkan Jumlah", text: $topUpAmountString)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.lightBackground)
                    .cornerRadius(10)
                
                Button(action: {
                    if let amount = Double(topUpAmountString), amount > 0 {
                        viewModel.topUpBalance(amount: amount)
                        topUpAmountString = ""
                        // Sembunyikan keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } else {
                        viewModel.alertMessage = "Masukkan jumlah yang valid."
                        viewModel.showAlert = true
                    }
                }) {
                    Text("Top Up")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .frame(maxHeight: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .frame(height: 50)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
    
    private var logoutButton: some View {
        Button(action: {
            userSession.logoutUser()
        }) {
            Text("LOG OUT")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryRed)
                .cornerRadius(15)
        }
    }
}
