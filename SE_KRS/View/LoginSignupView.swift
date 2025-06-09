//// File: View/LoginSignupView.swift
//import SwiftUI
//
//struct LoginSignupView: View { //
//    @EnvironmentObject var userSession: UserSession // Tambahkan ini untuk mengakses UserSession
//
//    @State var signUp: Bool = true //
//    @State var name = "" //
//    @State var phoneNumber = "" //
//    @State var email = "" //
//    @State var password = "" //
//    
//    // State untuk menampilkan alert
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    @State private var alertTitle = "Info"
//
//    var body: some View { //
//        ZStack { //
//            Color(red: 255/255, green: 241/255, blue: 230/255).edgesIgnoringSafeArea(.all) // Baris 18: Ini seharusnya tidak error jika body benar
//            
//            ScrollView { // Tambahkan ScrollView untuk konten yang mungkin panjang
//                VStack(alignment: .leading, spacing: 20) { //
//                    if signUp { //
//                        signUpContent()
//                    } else {
//                        loginContent()
//                    }
//                }
//                .padding() // Beri padding pada VStack utama
//                .frame(maxWidth: .infinity, maxHeight: .infinity) // Untuk alignment tengah jika konten sedikit
//            }
//        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    // MARK: - Subviews for Sign Up and Log In Content
//    @ViewBuilder
//    func signUpContent() -> some View {
//        Text("Sign Up") //
//            .font(.largeTitle) //
//            .fontWeight(.bold) //
//            .padding(.bottom, 20) //
//        
//        TextField("Name", text: $name).modifier(FormTextFieldStyle()) //
//        TextField("Phone Number", text: $phoneNumber).modifier(FormTextFieldStyle()).keyboardType(.phonePad) //
//        TextField("Email", text: $email).modifier(FormTextFieldStyle()).keyboardType(.emailAddress).autocapitalization(.none) //
//        SecureField("Password", text: $password).modifier(FormTextFieldStyle()) //
//        
//        Spacer() //
//        
//        HStack { //
//            Text("Already have an account?").font(.footnote) //
//            Button(action: { signUp = false }) { //
//                Text("Log In").font(.footnote).foregroundColor(.orange) //
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .center) //
//
//        Button(action: handleSignUp) { //
//            Text("SIGN UP").modifier(PrimaryButtonStyle()) //
//        }
//    }
//
//    @ViewBuilder
//    func loginContent() -> some View {
//        Text("Log In").font(.largeTitle).fontWeight(.bold).padding(.bottom, 20) //
//        TextField("Email", text: $email).modifier(FormTextFieldStyle()).keyboardType(.emailAddress).autocapitalization(.none) //
//        SecureField("Password", text: $password).modifier(FormTextFieldStyle()) //
//        Spacer() //
//        HStack { //
//            Text("Don't have an account yet?").font(.footnote) //
//            Button(action: { signUp = true }) { //
//                Text("Sign Up").font(.footnote).foregroundColor(.orange) //
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: .center) //
//        Button(action: handleLogin) { //
//            Text("LOG IN").modifier(PrimaryButtonStyle()) //
//        }
//    }
//
//    // MARK: - Helper Functions (Method dari struct LoginSignupView)
//    func handleSignUp() {
//        guard !name.isEmpty, !phoneNumber.isEmpty, !email.isEmpty, !password.isEmpty else {
//            alertTitle = "Sign Up Gagal"
//            alertMessage = "Semua field wajib diisi untuk mendaftar."
//            showingAlert = true
//            return
//        }
//        // Validasi email sederhana (opsional)
//        if !email.contains("@") {
//            alertTitle = "Sign Up Gagal"
//            alertMessage = "Format email tidak valid."
//            showingAlert = true
//            return
//        }
//
//        // Dummy sign up: Buat UserModel baru dan loginkan
//        let newUser = UserModel(name: name, phone: phoneNumber, email: email, password: password, balance: 150000) // Saldo awal dummy
//        
//        userSession.loginUser(user: newUser, message: "Pendaftaran Berhasil!")
//        
//        // Tidak perlu alert di sini jika navigasi otomatis terjadi karena perubahan userSession.isLoggedIn
//        // Namun, jika ingin memberi pesan selamat datang:
//        // alertTitle = "Sign Up Berhasil"
//        // alertMessage = "Selamat datang, \(name)!"
//        // showingAlert = true
//        print("Sign Up Dummy Berhasil untuk: \(email)")
//    }
//    
//    func handleLogin() { // Fungsi ini sekarang adalah method dari struct
////        guard !email.isEmpty, !password.isEmpty else {
////            alertTitle = "Login Gagal"
////            alertMessage = "Email dan password wajib diisi."
////            showingAlert = true
////            return // Baris 145: return di sini valid karena ini method struct, bukan di dalam body ViewBuilder
////        }
//
//        // Dummy login
//        // Di aplikasi nyata, Anda akan memvalidasi ke backend atau data yang tersimpan.
//        // Untuk dummy, kita bisa buat pengguna baru berdasarkan email, atau selalu loginkan user dummy.
//        // Di sini, kita akan selalu mencoba loginkan user berdasarkan input,
//        // atau Anda bisa memiliki logika untuk mencari user yang "sudah terdaftar" di DummyDataStore.
//        // Untuk kesederhanaan, kita buat UserModel baru dengan data yang diinput + saldo dummy.
//        
//        let loggedInUser = UserModel(name: name.isEmpty ? "Guest User" : name, // Gunakan nama jika diisi saat sign up, atau default
//                                     phone: phoneNumber.isEmpty ? "08123456789" : phoneNumber,
//                                     email: email,
//                                     password: password, // Seharusnya password di-hash dan diverifikasi
//                                     balance: 150000) // Saldo dummy untuk login
//        
//        
//        // Tidak perlu alert di sini jika navigasi otomatis terjadi
//        // alertTitle = "Login Berhasil"
//        // alertMessage = "Selamat datang kembali!"
//        // showingAlert = true
//        print("Login Dummy Berhasil untuk: \(email)")
//    }
//}
//
//// MARK: - Helper ViewModifiers (Jika Anda menggunakannya)
//struct FormTextFieldStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .frame(height: 50)
//            .foregroundColor(.black) // Changed for testing
//            .background(Color.white) // Changed for testing
//            .cornerRadius(30)
//            .shadow(color: .gray.opacity(0.3), radius: 3, x: 2, y: 2)
//    }
//}
//
//struct PrimaryButtonStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .fontWeight(.bold) //
//            .foregroundColor(.white) //
//            .frame(maxWidth: .infinity) //
//            .padding() //
//            .background(Color.red) //
//            .cornerRadius(25) //
//            .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 5) // Tambahkan shadow pada tombol
//    }
//}
//
//
//#Preview { //
//    LoginSignupView() //
//        .environmentObject(UserSession()) // Sediakan UserSession untuk preview
//}
