//
//  MenuView.swift
//  SE_KRS
//
//  Created by Stefanie Agahari on 25/05/25.
//

import SwiftUI

struct MenuView: View {
    @State var isSelected = false
    @State private var selectedButtonIndex: Int = 0
    let menuItems = ["Food", "Drink", "Others"]

    var body: some View {
        ZStack {
            // beige
            Color(red: 255 / 255, green: 241 / 255, blue: 230 / 255)
                .ignoresSafeArea(.container)

            Rectangle()
                // medium-orange
                .fill(Color(red: 255 / 255, green: 180 / 255, blue: 75 / 255))
                .frame(height: 400)
                .cornerRadius(100)
                .padding(.bottom, 700)

            ScrollView {
                MenuOutletCardView()
                    .padding(.top, 175)

                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { index in
                        Button(action: {
                            withAnimation(.easeInOut) {
                                selectedButtonIndex = index
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(
                                        selectedButtonIndex == index
                                            ? .red
                                            : .clear
                                    )
                                    .frame(width: 115, height: 30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(
                                                selectedButtonIndex == index
                                                    ? .clear : .red,
                                                lineWidth: 1)
                                    )

                                Text(menuItems[index])
                                    .foregroundColor(
                                        selectedButtonIndex == index
                                            ? .white : .red
                                    )
                                    .font(.system(size: 14))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    Text("Popular Foods")
                        .font(.system(size: 20, weight: .semibold))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                VStack {
                    ForEach(0..<4, id: \.self) { _ in
                        MenuCardView()
                            .padding(.vertical, 3)
                    }
                }
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    MenuView()
}
