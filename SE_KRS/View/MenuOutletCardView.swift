// File: View/MenuOutletCardView.swift (DIREVISI)
import SwiftUI

struct MenuOutletCardView: View {
    // <<< TAMBAHKAN PROPERTI INI >>>
    var restaurant: RestaurantModel

    @State var isLiked = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 350, height: 250)
                .cornerRadius(20)
                .padding()
                .shadow(radius: 5, x: 0, y: 5)
            
            Circle() // Lingkaran untuk gambar outlet/logo
                .fill(Color.white)
                .frame(width: 125, height: 125)
                .padding(.bottom, 225)
                .shadow(radius: 3)
            
            // Gunakan gambar dari restaurant.image
            Image(restaurant.image.isEmpty ? "nasi-goreng-44" : restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(Circle())
                .padding(.bottom, 225)
            
            VStack {
                // Gunakan data dari restaurant object
                Text(restaurant.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                    .lineLimit(1)
                
                // Anda bisa menambahkan kategori dari menu utama restoran jika ada
                // Text(restaurant.menu.category) // Contoh jika ada menu utama
                //     .font(.subheadline)
                //     .foregroundColor(.orange)
                
                HStack(spacing: 15) {
                    InfoCapsule(imageName: "star.fill", title: "Rating", value: String(format: "%.1f", restaurant.rating))
                    InfoCapsule(imageName: "clock.fill", title: "Delivery", value: "20 Mins") // Waktu delivery bisa dinamis
                }
                .padding(.top, 10)
            }
            .padding(.top, 60)

            Button(action: {
                withAnimation(.spring()) { isLiked.toggle() }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart").foregroundColor(.red).font(.system(size: 24))
            }
            .padding(.bottom, 175)
            .padding(.leading, 275)
        }
    }
}

// InfoCapsule tetap sama
struct InfoCapsule: View {
    let imageName: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: imageName).font(.system(size: 20))
            VStack (alignment: .leading) {
                Text(title).font(.caption).fontWeight(.semibold)
                Text(value).font(.system(size: 16, weight: .semibold))
            }
        }
        .frame(minWidth: 120, idealWidth: 140, minHeight: 50)
        .padding(.horizontal, 10)
        .background(Color.red)
        .cornerRadius(15)
        .foregroundColor(.white)
    }
}


