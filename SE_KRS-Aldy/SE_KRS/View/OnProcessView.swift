//
//  OnProcessView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import MapKit
import SwiftUI

struct OnProcessView: View {
    let location = CLLocationCoordinate2D(
        latitude: -7.2865722,
        longitude: 112.6320953
    )

    var body: some View {
        NavigationStack {
            ZStack {
                Map {
                    Marker("", coordinate: location)
                }
                .mapControlVisibility(.hidden)

                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(30)
                    .shadow(radius: 2, x: 0, y: -2)
                    .ignoresSafeArea(.all)
                    .padding(.top, 350)

                VStack {
                    Text("Your order is handled by,")
                        .font(.system(size: 14))

                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)

                        VStack(alignment: .leading) {
                            Text("Arif")
                                .font(.system(size: 18, weight: .semibold))

                            Text("Honda Vario L1234BA")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                        }

                        HStack {
                            Image(systemName: "ellipsis.message")
                            Image(systemName: "phone")
                        }
                        .foregroundColor(.red)
                        .padding(.leading, 40)

                    }.padding(.top, 10)

                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Pick Up Order at:")
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)

                                Text("Bubur Ayam Surabaya")
                                    .font(.system(size: 18))
                            }
                            .padding(.top, 20)
                            Spacer()
                        }

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Delivered to:")
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)

                                Text("Waterfront Citraland")
                                    .font(.system(size: 18))
                            }
                            .padding(.top, 20)
                            Spacer()
                        }

                        Divider()
                            .background(.black)
                            .padding(.vertical)

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Order Details")
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)

                                HStack {
                                    Text("Bubur Ayam Original")
                                        .font(.system(size: 18))
                                    Spacer()
                                    Text("1")
                                        .font(.system(size: 18))
                                }
                            }
                            .padding(.top, 10)
                            Spacer()
                        }
                    }.padding(30)
                }.padding(.top, 390)
            }
        }.tint(.black)
    }
}

#Preview {
    OnProcessView()
}
