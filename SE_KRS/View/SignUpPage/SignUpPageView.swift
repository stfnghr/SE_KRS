// File: View/SignUpPage/SignUpPageView.swift (REVISED)
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var name = ""
    @State private var phoneNumber = ""
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
                    
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    VStack {
                        Text("Buat Akun Baru")
                            .font(.largeTitle).fontWeight(.bold)
                        Text("Isi data untuk memulai perjalanan kulinermu.")
                            .font(.subheadline).foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 15) {
                        TextField("Nama Lengkap", text: $name)
                            .modifier(FormTextFieldStyle())
                            .textContentType(.name)
                        
                        TextField("Nomor Telepon", text: $phoneNumber)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                        
                        TextField("Email", text: $email)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                            .modifier(FormTextFieldStyle())
                            .textContentType(.newPassword)
                    }
                    
                    Spacer()
                    
                    Button(action: handleSignUp) {
                        Text("DAFTAR")
                            .modifier(PrimaryButtonStyle())
                    }
                    .padding(.top, 20)
                    
                    HStack {
                        Text("Sudah punya akun?")
                        // Navigasi kembali ke LoginView
                        NavigationLink("Masuk di sini.", destination: LoginView())
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
            Alert(title: Text("Daftar Gagal"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func handleSignUp() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "Nama, email, dan password wajib diisi."
            showingAlert = true
            return
        }
        if !email.contains("@") {
            alertMessage = "Format email tidak valid."
            showingAlert = true
            return
        }

        let newUser = UserModel(name: name, phone: phoneNumber, email: email, password: password, balance: 150000)
        userSession.loginUser(user: newUser, message: "Pendaftaran Berhasil!")
    }
}
