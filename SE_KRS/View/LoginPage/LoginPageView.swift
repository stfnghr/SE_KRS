// File: View/LoginPage/LoginPageView.swift (REVISED)
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var email = ""
    @State private var password = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 50)
                    
                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    // --- PERBAIKAN ALIGNMENT DI SINI ---
                    VStack(alignment: .center) { // 1. Tambahkan alignment .center
                        Text("Selamat Datang Kembali!")
                            .font(.largeTitle).fontWeight(.bold)
                        Text("Masuk untuk melanjutkan pesananmu.")
                            .font(.subheadline).foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity) // 2. Pastikan VStack memenuhi lebar
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                            .modifier(FormTextFieldStyle())
                            .textContentType(.password)
                    }
                    
                    Spacer()
                    
                    Button(action: handleLogin) {
                        Text("LOG IN")
                            .modifier(PrimaryButtonStyle())
                    }
                    .padding(.top, 20)
                    
                    HStack {
                        Text("Belum punya akun?")
                        NavigationLink("Daftar di sini.", destination: SignUpView())
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                    .font(.footnote)
                    
                    Spacer(minLength: 20)
                }
                .padding(30)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Login Gagal"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Email dan password wajib diisi."
            showingAlert = true
            return
        }
        
        // Di aplikasi nyata, Anda akan memvalidasi dengan data yang ada.
        // Untuk dummy, kita buat user baru berdasarkan input.
        let loggedInUser = UserModel(name: "Pengguna Login",
                                     phone: "08123456789",
                                     email: email,
                                     password: password,
                                     balance: 150000)
        
        userSession.loginUser(user: loggedInUser, message: "Login Berhasil!")
    }
}


// --- DEFINISI VIEW MODIFIER DITEMPATKAN DI SINI ---

struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .cornerRadius(15)
            .shadow(color: .red.opacity(0.3), radius: 8, y: 4)
    }
}
