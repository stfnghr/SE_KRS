//
//  ProfileView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255)
                .ignoresSafeArea(.all)

            Rectangle()
                .fill(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255))
                .cornerRadius(30)
                .padding(.top, 250)
                .ignoresSafeArea(.all)

            Circle()
                .fill(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255))
                .frame(width: 125, height: 125)
                .padding(.bottom, 400)

            Circle()
                .fill(.white)
                .frame(width: 110, height: 110)
                .padding(.bottom, 400)

            VStack(alignment: .center) {
                Text("John Doe")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(
                        Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255))

                Text("+62 812-3456-7890")
                    .font(.subheadline)

                Text("johndoe@email.com")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)

                Text(
                    "Jl. Melati No. 123, RT 04 / RW 07, Kelurahan Sukamaju, Kecamatan Cilandak, Kota Jakarta Selatan"
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 100)
            .padding(.horizontal, 70)
        }

    }
}

#Preview {
    ProfileView()
}
