// File: View/AnimatedNavbar.swift
import SwiftUI

struct AnimatedNavbar: View {
    @Namespace var animation
    @State private var selectedTab: Tab = .home
    @State private var circlePosition: CGFloat = 0
    @EnvironmentObject var userSession: UserSession

    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case cart = "cart.fill"
        case progress = "list.clipboard.fill"
        case person = "person.fill"
    }

    let navbarHeight: CGFloat = 70 // Tinggi dasar navbar
    var safeAreaBottomInset: CGFloat {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .cart:
                    CartView()
                case .progress:
                    ActivityView(userSession: userSession)
                case .person:
                    ProfileView(userSession: userSession)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, navbarHeight)


            ZStack {
                NavbarBackgroundShape(circlePosition: circlePosition, tabCount: CGFloat(Tab.allCases.count))
                    .fill(Color.red)
                    .shadow(radius: 3, x: 0, y: -5)
                    .frame(height: navbarHeight + safeAreaBottomInset)
                
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Spacer()
                        VStack(spacing: 4) {
                            ZStack {
                                if selectedTab == tab {
                                    Circle()
                                        .fill(Color.white)
                                        .matchedGeometryEffect(id: "selected_tab_circle_navbar_v5", in: animation)
                                        .frame(width: 56, height: 56)
                                        .offset(y: -navbarHeight / 2.5)

                                    Image(systemName: tab.rawValue)
                                        .font(.system(size: 22))
                                        .foregroundColor(.red)
                                        .offset(y: -navbarHeight / 2.5)
                                        .transition(.scale(scale: 0.5, anchor: .center).combined(with: .opacity))
                                } else {
                                    Image(systemName: tab.rawValue)
                                        .font(.system(size: 22))
                                        .foregroundColor(.white.opacity(0.8))
                                        .transition(.opacity)
                                }
                            }
                            .frame(height: 56)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: navbarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.interpolatingSpring(mass: 0.8, stiffness: 150, damping: 15)) {
                                selectedTab = tab
                                if let tabIndex = Tab.allCases.firstIndex(of: tab) {
                                   circlePosition = CGFloat(tabIndex)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.bottom, safeAreaBottomInset)
                .frame(height: navbarHeight + safeAreaBottomInset)
            }
            .frame(maxWidth: .infinity)
            .frame(height: navbarHeight + safeAreaBottomInset)
            .animation(.easeInOut(duration: 0.3), value: circlePosition)
            .onAppear {
                if let initialTabIndex = Tab.allCases.firstIndex(of: selectedTab) {
                    circlePosition = CGFloat(initialTabIndex)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        // MARK: - SARAN PERBAIKAN
        // Coba nonaktifkan baris di bawah ini untuk melihat apakah error constraint hilang
//         .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension AnimatedNavbar.Tab {
    var index: Int {
        guard let index = Self.allCases.firstIndex(of: self) else {
            fatalError("Tab tidak ditemukan dalam allCases.")
        }
        return index
    }
}

struct NavbarBackgroundShape: Shape {
    var circlePosition: CGFloat
    var tabCount: CGFloat
    let navbarBaseHeight: CGFloat = 70

    var animatableData: CGFloat {
        get { circlePosition }
        set { circlePosition = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let actualNavbarTopY = rect.maxY - navbarBaseHeight
        
        let cutoutRadius: CGFloat = 32
        let cutoutDepthUpwards: CGFloat = 28

        guard tabCount > 0 else { return path }
        let tabWidth = rect.width / tabCount
        let circleCenterX = tabWidth * circlePosition + tabWidth / 2
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: actualNavbarTopY))
        
        path.addLine(to: CGPoint(x: circleCenterX - cutoutRadius, y: actualNavbarTopY))

        path.addQuadCurve(
            to: CGPoint(x: circleCenterX, y: actualNavbarTopY - cutoutDepthUpwards),
            control: CGPoint(x: circleCenterX - cutoutRadius * 0.75, y: actualNavbarTopY - cutoutDepthUpwards * 0.1)
        )
        path.addQuadCurve(
            to: CGPoint(x: circleCenterX + cutoutRadius, y: actualNavbarTopY),
            control: CGPoint(x: circleCenterX + cutoutRadius * 0.75, y: actualNavbarTopY - cutoutDepthUpwards * 0.1)
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: actualNavbarTopY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview("AnimatedNavbar_LayoutFix_Final") {
    let previewUserSession = UserSession()
    let previewCartViewModel = CartViewModel(userSession: previewUserSession)

    return AnimatedNavbar()
        .environmentObject(previewUserSession)
        .environmentObject(previewCartViewModel)
}
