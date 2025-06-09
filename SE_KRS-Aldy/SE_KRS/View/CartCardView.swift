//
//  CartCardView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct CartCardView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 150)
            
            Rectangle()
                .fill(Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .cornerRadius(25)
                .shadow(radius: 3, x: 0, y: -3)
                .padding(.horizontal, 20)

            HStack {
                Text("1 item")
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                Text("20,000")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Image(systemName: "cart.badge.plus")
                    .foregroundColor(.white)
            }.padding(.horizontal, 50)
        }
    }
}

#Preview {
    CartCardView()
}
