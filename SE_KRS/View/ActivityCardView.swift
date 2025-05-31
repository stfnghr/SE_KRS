//
//  ActivityCardView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 26/05/25.
//

import SwiftUI

struct ActivityCardView: View {
    var body: some View {
        ZStack {
            Rectangle()
//                .fill(Color.gray.opacity(0.3))
                .fill(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .cornerRadius(25)
                .shadow(radius: 3, x: 0, y: 5)

            HStack {
                VStack(alignment: .leading) {
                    Text("Nasi Goreng Spesial")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.bottom, 5)

                    Text("25 Mei 2025")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                }

                Image("nasi-goreng")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipped()
                    .cornerRadius(20)
                    .padding(.leading, 30)
            }

        }.padding(.horizontal, 20)
    }
}

#Preview {
    ActivityCardView()
}
