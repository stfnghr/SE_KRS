// File: View/LandingView.swift
import SwiftUI

struct LandingView: View {
    var body: some View {
        // Anda TIDAK PERLU @EnvironmentObject di sini, karena LandingView tidak
        // secara langsung menggunakan userSession. Ia hanya perlu meneruskannya
        // ke view selanjutnya (LoginView/SignUpView), dan itu terjadi secara otomatis.
        
        NavigationView {
            ZStack {
                // Background color yang senada dengan tema aplikasi
                Color(red: 255/255, green: 241/255, blue: 230/255).edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()

                    // App Logo atau Nama Aplikasi
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.red)
                    
                    Text("Selamat Datang di FoodDeli")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.orange)

                    Text("Pesan makanan favoritmu dengan mudah dan cepat, kapan pun, di mana pun.")
                        .font(.headline)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)

                    Spacer()
                    Spacer()

                    // Tombol Aksi
                    VStack(spacing: 15) {
                        // LoginView dan SignUpView akan secara otomatis menerima
                        // userSession dari environment yang di-provide oleh SE_KRSApp
                        NavigationLink(destination: LoginView()) {
                            Text("MASUK")
                                .modifier(PrimaryButtonStyle())
                        }
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("DAFTAR SEKARANG")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.red, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
        // HAPUS BARIS .environmentObject(UserSession()) DARI SINI
        .accentColor(.red)
    }
}

#Preview {
    LandingView()
        // Baris di bawah ini TIDAK MASALAH, karena hanya untuk keperluan preview.
        .environmentObject(UserSession())
}
