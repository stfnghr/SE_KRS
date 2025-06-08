// File: View/SignUpView.swift
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSignupSuccessful = false

    // State untuk alert
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Color("Beige").ignoresSafeArea()

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

                    NavigationLink(
                        destination: MainView().navigationBarBackButtonHidden(
                            true),
                        isActive: $isSignupSuccessful
                    ) {
                        EmptyView()  // Tampilannya kosong karena kita tidak ingin menampilkannya
                    }

                    HStack {
                        Text("Sudah punya akun?")
                        // NavigationLink tidak berfungsi baik jika view ini sudah di dalam link.
                        // Kita gunakan Environment's presentationMode untuk kembali.
                        Button("Masuk di sini.") {
                            // Aksi untuk kembali, jika diperlukan.
                            // Dalam kasus ini, NavigationStack sudah menangani tombol back.
                        }
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

        userSession.loginUser(user: newUser, message: "Pendaftaran Berhasil!")
        
        isSignupSuccessful = true

        print("Sign Up Dummy Berhasil untuk: \(email)")
    }
}

#Preview {
    NavigationView {
        SignUpView()
            .environmentObject(UserSession())
    }
}
