//
//  LoginSignupView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 24/05/25.
//

import SwiftUI

struct LoginSignupView: View {
    @State var signUp: Bool = true
    @State var name = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            Color(red: 255/255, green: 241/255, blue: 230/255).edgesIgnoringSafeArea(.all)
            
            if signUp {
                VStack (alignment: .leading, spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    TextField("Name", text: $name)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                    
                    Spacer()
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        Button(action: {
                            signUp = false
                        }) {
                            Text("Log In")
                                .font(.footnote)
                                .foregroundColor(.orange)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        //
                    }) {
                        Text("SIGN UP")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .cornerRadius(25)
                    }
                }
            } else {
                VStack (alignment: .leading, spacing: 20) {
                    Text("Log In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .foregroundColor(.orange)
                        .background(.white)
                        .cornerRadius(30)
                    
                    Spacer()
                    
                    HStack {
                        Text("Don't have an account yet?")
                            .font(.footnote)
                        Button(action: {
                            signUp = true
                        }) {
                            Text("Sign Up")
                                .font(.footnote)
                                .foregroundColor(.orange)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button(action: {
                        //
                    }) {
                        Text("LOG IN")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .cornerRadius(25)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginSignupView()
}
