//
//  HomeView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 25/05/25.
//

import SwiftUI

struct HomeView: View {
    @State var search = ""
    @State var currentPage: Int? = 0
    let totalPages = 3

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea(.all)
                
                Rectangle()
                    .fill(Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255))
                    .cornerRadius(30)
                    .padding(.top, 250)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 15)
                        
                        TextField("Lagi mau makan apa?", text: $search)
                            .font(.system(size: 14)).padding(.vertical, 12)
                        
                        if !search.isEmpty {
                            Button(action: {
                                search = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 15)
                        }
                    }
                    .frame(width: 335, height: 40)
                    .background(.white)
                    .cornerRadius(30)
                    .shadow(radius: 5, x: 0, y: 1)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .padding(.top, 160)
                    
                    ScrollView {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 150)
                                    .cornerRadius(30)
                                    .overlay(
                                        GeometryReader { geometry in
                                            let pageWidth = geometry.size.width
                                            
                                            ScrollView(
                                                .horizontal, showsIndicators: false
                                            ) {
                                                HStack(spacing: 0) {
                                                    ForEach(0..<3, id: \.self) {
                                                        index in
                                                        Image("foods")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(
                                                                width: pageWidth,
                                                                height: 150
                                                            )
                                                            .cornerRadius(30)
                                                            .clipped()
                                                            .id(index)
                                                    }
                                                }
                                                .scrollTargetLayout()
                                            }
                                            .scrollTargetBehavior(.paging)
                                            .scrollPosition(id: $currentPage)
                                        }
                                    )
                                    .padding()
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<3, id: \.self) { index in
                                        Circle()
                                            .fill(
                                                currentPage == index
                                                ? Color.orange
                                                : Color.gray.opacity(0.4)
                                            )
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.white)
                                .cornerRadius(20)
                                .padding(.top, 120)
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Resto Sekitarmu")
                                        .font(.headline)
                                    Text(
                                        "Kami pilihin tempat yang lagi buka dan enak."
                                    )
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Lihat Semua")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 5)
                                        .padding()
                                        .background(.red)
                                        .cornerRadius(25)
                                }
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(0..<4, id: \.self) { _ in
                                        FoodCardView().whiteCard()
                                    }
                                }
                                .padding()
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Pilih Makananmu")
                                        .font(.headline)
                                    Text("Kita sediakan pilihan makanan untuk kamu")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Lihat Semua")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 5)
                                        .padding()
                                        .background(.red)
                                        .cornerRadius(25)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            
                            VStack {
                                ForEach(0..<3, id: \.self) { _ in
                                    HStack {
                                        ForEach(0..<3, id: \.self) { _ in
                                            FoodCardView().redCard()
                                                .padding(3)
                                        }
                                    }.padding(5)
                                }
                            }
                        }
                    }
                }.padding(10)
            }
        } .tint(.black)
    }
}

#Preview {
    HomeView()
}
