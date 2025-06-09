// File: View/LandingPage/LandingPageView.swift (REVISED)
import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 245/255, green: 245/255, blue: 245/255).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer(minLength: 100)
                        
                
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        
                        VStack {
                            Text("Selamat Datang")
                                .font(.largeTitle).fontWeight(.bold)
                            Text("Pesan makanan favoritmu dengan beberapa klik.")
                                .font(.subheadline).foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                        
                        // Tombol Masuk (Primary)
                        NavigationLink(destination: LoginView()) {
                            Text("MASUK")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(15)
                                .shadow(color: .red.opacity(0.3), radius: 8, y: 4)
                        }
                        
                        // Tombol Daftar (Secondary)
                        NavigationLink(destination: SignUpView()) {
                            Text("DAFTAR SEKARANG")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .accentColor(.red)
    }
}
