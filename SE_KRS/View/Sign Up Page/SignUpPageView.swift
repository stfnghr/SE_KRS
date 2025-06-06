// File: View/SignUpView.swift
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""

    // State untuk alert
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Color(red: 255/255, green: 241/255, blue: 230/255).edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer(minLength: 30)

                    Text("Buat Akun Baru")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkBrown"))

                    Text(
                        "Isi data di bawah untuk memulai perjalanan kulinermu."
                    )
                    .font(.headline)
                    .foregroundColor(.gray)

                    VStack(spacing: 15) {
                        TextField("Nama Lengkap", text: $name)
                            .modifier(FormTextFieldStyle())

                        TextField("Nomor Telepon", text: $phoneNumber)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.phonePad)

                        TextField("Email", text: $email)
                            .modifier(FormTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .modifier(FormTextFieldStyle())
                    }
                    .padding(.top, 30)

                    Spacer()

                    Button(action: handleSignUp) {
                        Text("SIGN UP")
                            .modifier(PrimaryButtonStyle())
                    }
                    .padding(.top, 40)

                    HStack {
                        Text("Sudah punya akun?")
                        NavigationLink(
                            "Masuk di sini.", destination: LoginView()
                        )
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    }
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                }
                .padding(30)
            }
        }
        .navigationTitle("Daftar Akun")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Sign Up Gagal"), message: Text(alertMessage),
                dismissButton: .default(Text("OK")))
        }
    }

    func handleSignUp() {
        guard !name.isEmpty, !phoneNumber.isEmpty, !email.isEmpty,
            !password.isEmpty
        else {
            alertMessage = "Semua kolom wajib diisi untuk mendaftar."
            showingAlert = true
            return
        }
        if !email.contains("@") {
            alertMessage = "Format email tidak valid."
            showingAlert = true
            return
        }

        let newUser = UserModel(
            name: name, phone: phoneNumber, email: email, password: password,
            balance: 150000)

        // --- PERBAIKI BARIS INI ---
        // Pastikan Anda menyertakan parameter 'message'
        userSession.loginUser(user: newUser, message: "Pendaftaran Berhasil!")
        // -------------------------

        print("Sign Up Dummy Berhasil untuk: \(email)")
    }
}

// MARK: - Helper ViewModifiers (Jika Anda menggunakannya)
struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
            .foregroundColor(.black)  // Changed for testing
            .background(Color.white)  // Changed for testing
            .cornerRadius(30)
            .shadow(color: .gray.opacity(0.3), radius: 3, x: 2, y: 2)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)  //
            .foregroundColor(.white)  //
            .frame(maxWidth: .infinity)  //
            .padding()  //
            .background(Color.red)  //
            .cornerRadius(25)  //
            .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 5)  // Tambahkan shadow pada tombol
    }
}

#Preview {
    NavigationView {
        SignUpView()
            .environmentObject(UserSession())
    }
}
