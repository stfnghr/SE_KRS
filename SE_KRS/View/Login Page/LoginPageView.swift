// File: View/LoginView.swift
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginSuccessful = false

    // State untuk alert
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Color("Beige").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer(minLength: 50)

                    Text("Masuk ke Akun Anda")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkBrown"))

                    Text("Selamat datang kembali! Silakan masuk.")
                        .font(.headline)
                        .foregroundColor(.gray)

                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .modifier(FormTextFieldStyle())
                    }
                    .padding(.top, 30)

                    Spacer()

                    Button(action: handleLogin) {
                        Text("LOG IN")
                            .modifier(PrimaryButtonStyle())
                    }
                    .padding(.top, 40)

                    NavigationLink(
                        destination: MainView().navigationBarBackButtonHidden(
                            true),
                        isActive: $isLoginSuccessful
                    ) {
                        EmptyView()  // Tampilannya kosong karena kita tidak ingin menampilkannya
                    }

                    HStack {
                        Text("Belum punya akun?")
                        NavigationLink(
                            "Daftar di sini.", destination: SignUpView()
                        )
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .navigationBarBackButtonHidden(true)
                    }
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                }
                .padding(30)
            }
        }
        .navigationTitle("Masuk")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Login Gagal"), message: Text(alertMessage),
                dismissButton: .default(Text("OK")))
        }
    }

    func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Email dan password wajib diisi."
            showingAlert = true
            return
        }

        // Logika login dummy yang sama seperti sebelumnya
        let loggedInUser = UserModel(
            name: "Pengguna Login",
            phone: "08123456789",
            email: email,
            password: password,
            balance: 150000)

        userSession.loginUser(user: loggedInUser, message: "Login Berhasil!")

        isLoginSuccessful = true
    }
}

#Preview {
    // Untuk preview, kita butuh NavigationView
    NavigationView {
        LoginView()
            .environmentObject(UserSession())
    }
}
