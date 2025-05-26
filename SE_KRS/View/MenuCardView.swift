//
//  MenuCardView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 25/05/25.
//

import SwiftUI
struct MenuCardView: View {
    @State var isLiked = false
    @State var showCartCard = false // Renamed for clarity
    
    var body: some View {
        ZStack {
            // Card Background
            Rectangle()
                .fill(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .cornerRadius(25)
                .shadow(radius: 3, x: 0, y: 5)
            
            // Card Content
            HStack {
                Image("nasi-goreng")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipped()
                    .cornerRadius(25)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Nasi Goreng Spesial")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isLiked.toggle()
                            }
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.system(size: 18))
                        }
                        .padding(.leading, 15)
                    }
                    
                    Text("Nasi goreng spesial, ditambah telor mata sapi")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                    
                    HStack {
                        Text("Rp47,500")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        // Cart Button
                        Button(action: {
                            withAnimation {
                                showCartCard = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 12))
                                Text("Add")
                                    .font(.system(size: 12))
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red)
                            .cornerRadius(25)
                        }
                    }
                }
                .padding(.trailing, 25)
            }
        }
        .padding(.horizontal, 20)
        .overlay(
            Group {
                if showCartCard {
                    VStack {
                        Spacer()
                        
                        CartCardView()
                            .transition(.move(edge: .bottom))
                            .padding(.bottom, 30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showCartCard = false
                        }
                    }
                }
            }
        )
    }
}

#Preview {
    MenuCardView()
}
