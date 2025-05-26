//
//  CartView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack (alignment: .bottom) {
                    Image("nasi-goreng")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipped()
                        .cornerRadius(20)
                    
                    Text("Nasi Goreng 44")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                        .padding(.bottom, 10)
                }
                .padding(.trailing, 100)
                .padding(.top, 50)
                
                Divider()
                    .background(.black)
                    .padding()
                
                HStack {
                    Text("Nasi Goreng Special")
                    Spacer()
                    Text("1")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))

                HStack {
                    Text("Nasi Goreng Special")
                    Spacer()
                    Text("1")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))
                
                Divider()
                    .background(.black)
                    .padding()
                
                HStack {
                    Text("Harga")
                    Spacer()
                    Text("40,000")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))

                HStack {
                    Text("Ongkir")
                    Spacer()
                    Text("10,000")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))

                HStack {
                    Text("Diskon")
                    Spacer()
                    Text("-20,000")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))

                HStack {
                    Text("Total")
                    Spacer()
                    Text("30,000")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))

                HStack {
                    Text("Metode Pembayaran")
                    Spacer()
                    Text("Tunai")
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .font(.system(size: 14))
                
                Button(action: {}) {
                    Text("PLACE AN ORDER")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(25)
                        .padding(.top, 100)
                }
                
                Spacer()
                
            } .padding()
        } .tint(.orange)
    }
}

#Preview {
    CartView()
}
