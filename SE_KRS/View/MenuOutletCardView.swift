//
//  MenuOutletCardView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 25/05/25.
//

import SwiftUI

struct MenuOutletCardView: View {
    @State var isLiked = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 350, height: 250)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 5, x: 0, y: 5)
            
            Circle()
                .fill(Color.white)
                .frame(width: 125, height: 125)
                .padding(.bottom, 225)
            
            Circle()
                .fill(Color.orange.opacity(0.5))
                .frame(width: 110, height: 110)
                .padding(.bottom, 225)
            
            VStack {
                Text("Nasi Goreng 44")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Jln.in Aja Dulu")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                Text("Nasi, Cepat Saji")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                HStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 25))
                        
                        VStack (alignment: .leading) {
                            Text("Rating")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("4.9")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(width: 140, height: 50)
                    .background(.red)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    
                    
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 25))
                        
                        VStack (alignment: .leading) {
                            Text("Delivery")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("20 Mins")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(width: 140, height: 50)
                    .background(.red)
                    .cornerRadius(15)
                    .foregroundColor(.white)
                } .padding(.top, 10)
            } .padding(.top, 50)
            
            Button(action: {
                withAnimation(.spring()) {
                    isLiked.toggle()
                }
            }) {
                Image(
                    systemName: isLiked
                        ? "heart.fill" : "heart"
                )
                .foregroundColor(isLiked ? .red : .red)
                .font(.system(size: 24))
            }
            .padding(.bottom, 175)
            .padding(.leading, 275)
        }
    }
}

#Preview {
    MenuOutletCardView()
}
