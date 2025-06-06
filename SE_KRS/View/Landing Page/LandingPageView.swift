// File: View/LandingView.swift
import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background color yang senada dengan tema aplikasi
                Color("Beige") // Anda bisa membuat custom color set bernama "Beige"
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    // App Logo atau Nama Aplikasi
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.red)
                    
                    Text("Selamat Datang di SE-KRS")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("DarkBrown")) // Buat custom color "DarkBrown"

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
            .navigationBarHidden(true) // Sembunyikan navigation bar di halaman ini
        }
        .environmentObject(UserSession()) // Sediakan UserSession untuk preview
        .accentColor(.red) // Mengubah warna back button di halaman selanjutnya menjadi merah
    }
}

// Tambahkan custom color di Assets.xcassets Anda
// 1. "Beige": Red: 255, Green: 241, Blue: 230
// 2. "DarkBrown": Pilih warna coklat tua yang sesuai

#Preview {
    LandingView()
}
