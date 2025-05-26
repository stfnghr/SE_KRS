//
//  DetailMenuView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct DetailMenuView: View {
    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)
                .ignoresSafeArea(.all)
            
            VStack {
                Image("nasi-goreng")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 400)
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack (alignment: .leading) {
                    Text("Nasi Goreng Spesial")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 3)
                    
                    Text("Nasi goreng spesial dengan cita rasa gurih khas, dilengkapi dengan telur, ayam suwir, sosis, dan taburan bawang goreng yang menggugah selera.")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                } .padding()
                
                HStack {
                    Text("Rp47,500")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack {  // Wrap contents in HStack
                            Image(systemName: "cart.fill")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                            
                            Text("Tambahkan ke Keranjang")
                                .font(.system(size: 13))
                                .fontWeight(.medium)
                        }
                        .frame(width: 210, height: 30)
                    }
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(25)
                    
                } .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    DetailMenuView()
}
