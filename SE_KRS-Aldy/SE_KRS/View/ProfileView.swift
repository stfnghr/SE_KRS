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
            ZStack {
                Color.lightBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        profileHeaderCard
                        
                        balanceCard
                        
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
        .asCard() // Menggunakan modifier .asCard() agar konsisten
    }
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Saldo & Top Up")
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            HStack {
                Text("Saldo Anda Saat Ini")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                Spacer()
                Text("Rp \(String(format: "%.0f", viewModel.userBalance))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryRed)
            }
            
            HStack(spacing: 10) {
                TextField("Masukkan Jumlah Top Up", text: $topUpAmountString)
                    .keyboardType(.numberPad)
                    .padding(12)
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
                        .background(Color.primaryRed) // Warna diubah menjadi merah
                        .cornerRadius(10)
                }
            }
            .frame(height: 48)
        }
        .asCard()
    }
    
    private var logoutButton: some View {
        Button(action: {
            userSession.logoutUser()
        }) {
            HStack {
                Spacer()
                Text("LOG OUT")
                    .fontWeight(.bold)
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.primaryRed)
            .cornerRadius(15)
        }
    }
}

// View helper untuk baris opsi agar rapi
struct OptionRow: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(8)

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
    }
}
