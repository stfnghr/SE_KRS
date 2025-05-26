//
//  FoodCardView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 24/05/25.
//

import SwiftUI

struct FoodCardView: View {
    @State var image = ""
    
    var body: some View {
        redCard() // or whiteCard()
    }
    
    // Red version
    func redCard() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.red)
                .cornerRadius(15)
                .frame(width: 105, height: 100)
                .shadow(radius: 3, x: 0, y: 5)

            VStack {
                Image("nasi-goreng")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 105, height: 60)
                    .clipped()
                    .cornerRadius(15)
                
                Text("Restaurant Name")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Description")
                    .font(.system(size: 8))
                    .foregroundColor(.white)
            }
        }
    }
    
    // White version
    func whiteCard() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(15)
                .frame(width: 175, height: 175)
                .shadow(radius: 3, x: 0, y: 5)

            VStack {
                Image("nasi-goreng")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 175, height: 120)
                    .clipped()
                    .cornerRadius(15)
                
                Text("Restaurant Name")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black) // Changed to black for better visibility
                Text("Description")
                    .font(.caption)
                    .foregroundColor(.gray) // Changed to gray for better visibility
            }
        }
    }
}

#Preview {
    VStack {
        FoodCardView().redCard()
        FoodCardView().whiteCard()
    }
}
