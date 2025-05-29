//
//  FoodCardView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 24/05/25.
//

import SwiftUI

struct FoodCardView: View {
    @State var image = ""
    var menu: MenuModel
    var restaurant: RestaurantModel
    
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
                
                Text(menu.category)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
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
                
                Text(restaurant.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black) 
            }
        }
    }
}

#Preview {
    VStack {
        FoodCardView(
            menu: MenuModel(
                name: "Bubur Ayam Original",
                price: 12000,
                description: "Bubur + ayam + cakwe + kulit pangsit + bawang goreng + kecap asin",
                category: "Bubur",
                image: "bubur-ayam-ori"),
            restaurant: RestaurantModel(
                name: "Koo-pi",
                address: "Ruko Mutiara No.8",
                rating: 4.9,
                image: "koopi",
                menu: MenuModel(
                    name: "Kopi Gula Aren",
                    price: 18000,
                    description: "Kopi, susu, dan gula aren.",
                    category: "Kopi",
                    image: "kopi-gula-aren")
            )
        ).redCard()
        
        FoodCardView(
            menu: MenuModel(
                name: "Bubur Ayam Original",
                price: 12000,
                description: "Bubur + ayam + cakwe + kulit pangsit + bawang goreng + kecap asin",
                category: "Bubur",
                image: "bubur-ayam-ori"),
            restaurant: RestaurantModel(
                name: "Koo-pi",
                address: "Ruko Mutiara No.8",
                rating: 4.9,
                image: "koopi",
                menu: MenuModel(
                    name: "Kopi Gula Aren",
                    price: 18000,
                    description: "Kopi, susu, dan gula aren.",
                    category: "Kopi",
                    image: "kopi-gula-aren")
            )
        ).whiteCard()
    }
}
