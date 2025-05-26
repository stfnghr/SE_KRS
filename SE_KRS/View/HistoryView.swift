//
//  HistoryView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(20)
                        .shadow(radius: 3, x: 0, y: 3)
                        .overlay(
                            VStack {
                                Text("Nasi Goreng 44")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.top, 10)
                                
                                Text("25 Mei 2025")
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)
                                    .padding(.bottom, 20)

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

                                Spacer()

                                Text("Informasi Kurir")
                                    .font(.subheadline)

                                HStack {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.gray)

                                    VStack(alignment: .leading) {
                                        Text("Arif")
                                            .font(.system(size: 14))
                                        Text("Honda Vario L1234BA")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }

                                    VStack {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.yellow)

                                        Text("5")
                                            .font(.caption)
                                    }.padding(.leading, 100)

                                }
                            }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 30)
                        )
                        .frame(maxWidth: .infinity)
                }

                Button(action: {}) {
                    Text("DOWNLOAD RECEIPT")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(25)
                        .padding(.top)
                }
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255))
        }
        .navigationTitle("Your Receipt")
    }
}

#Preview {
    HistoryView()
}
