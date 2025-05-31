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
        // ZStack TERLUAR: Mengatur alignment navbar ke bawah
        ZStack(alignment: .bottom) { //
            
            // 1. KONTEN HALAMAN (di atas navbar)
            // ZStack ini akan mengisi semua ruang yang tidak ditempati navbar.
            ZStack { //
                switch selectedTab { //
                case .home: //
                    HomeView()
                case .cart: //
                    CartView() // CartView akan mengambil userSession & cartViewModel dari environment
                case .progress: //
                    ActivityView(userSession: userSession)
                case .person: //
                    ProfileView(userSession: userSession)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Pastikan konten mengisi ruang
            // Padding bawah untuk konten agar tidak tertutup oleh area visual navbar (bukan safe area)
            // Ini penting agar ScrollView di dalam HomeView, CartView, dll., tidak terpotong.
            .padding(.bottom, navbarHeight)


            // 2. UI NAVBAR (akan berada di bawah karena ZStack terluar alignment: .bottom)
            ZStack { //
                NavbarBackgroundShape(circlePosition: circlePosition, tabCount: CGFloat(Tab.allCases.count)) //
                    .fill(Color.red) //
                    .shadow(radius: 3, x: 0, y: -5) //
                    // Frame untuk shape background navbar, tingginya adalah tinggi dasar + safe area
                    .frame(height: navbarHeight + safeAreaBottomInset)
                
                HStack(spacing: 0) { //
                    ForEach(Tab.allCases, id: \.self) { tab in //
                        Spacer() //
                        VStack(spacing: 4) { //
                            ZStack { //
                                if selectedTab == tab { //
                                    Circle() //
                                        .fill(Color.white) //
                                        .matchedGeometryEffect(id: "selected_tab_circle_navbar_v5", in: animation) // ID Unik baru
                                        .frame(width: 56, height: 56) //
                                        .offset(y: -navbarHeight / 2.5)  // Offset relatif terhadap tinggi navbar dasar

                                    Image(systemName: tab.rawValue) //
                                        .font(.system(size: 22)) //
                                        .foregroundColor(.red) //
                                        .offset(y: -navbarHeight / 2.5) //
                                        .transition(.scale(scale: 0.5, anchor: .center).combined(with: .opacity)) //
                                } else {
                                    Image(systemName: tab.rawValue) //
                                        .font(.system(size: 22)) //
                                        .foregroundColor(.white.opacity(0.8)) //
                                        .transition(.opacity) //
                                }
                            }
                            .frame(height: 56)
                        }
                        .frame(maxWidth: .infinity) //
                        .frame(height: navbarHeight) // Tinggi area tap ikon = tinggi dasar navbar
                        .contentShape(Rectangle()) //
                        .onTapGesture { //
                            withAnimation(.interpolatingSpring(mass: 0.8, stiffness: 150, damping: 15)) { //
                                selectedTab = tab //
                                if let tabIndex = Tab.allCases.firstIndex(of: tab) { //
                                   circlePosition = CGFloat(tabIndex) //
                                }
                            }
                        }
                        Spacer() //
                    }
                }
                // Padding bawah untuk HStack ikon agar memperhitungkan safe area
                .padding(.bottom, safeAreaBottomInset)
                .frame(height: navbarHeight + safeAreaBottomInset) // Tinggi total HStack termasuk area untuk safe area
            }
            .frame(maxWidth: .infinity) // Pastikan ZStack navbar mengisi lebar
            .frame(height: navbarHeight + safeAreaBottomInset) // Tinggi total ZStack navbar
            .animation(.easeInOut(duration: 0.3), value: circlePosition) //
            .onAppear { //
                if let initialTabIndex = Tab.allCases.firstIndex(of: selectedTab) { //
                    circlePosition = CGFloat(initialTabIndex) //
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom) // Ini akan membuat ZStack terluar mengabaikan safe area bawah, sehingga navbar bisa menyentuh tepi
        .ignoresSafeArea(.keyboard, edges: .bottom) // Tambahkan ini agar keyboard tidak mendorong navbar
    }
}

extension AnimatedNavbar.Tab { //
    var index: Int { //
        guard let index = Self.allCases.firstIndex(of: self) else { //
            fatalError("Tab tidak ditemukan dalam allCases.")
        }
        return index //
    }
}

struct NavbarBackgroundShape: Shape { //
    var circlePosition: CGFloat //
    var tabCount: CGFloat //
    let navbarBaseHeight: CGFloat = 70 // Definisikan tinggi dasar navbar di sini juga jika perlu

    var animatableData: CGFloat { //
        get { circlePosition } //
        set { circlePosition = newValue } //
    }

    func path(in rect: CGRect) -> Path { //
        var path = Path() //
        
        // rect.minY di sini adalah bagian atas dari frame NavbarBackgroundShape
        // rect.height di sini adalah tinggi total NavbarBackgroundShape (termasuk safe area)
        // Kita ingin cutout relatif terhadap garis atas imajiner navbar (navbarBaseHeight dari bawah)
        
        let actualNavbarTopY = rect.maxY - navbarBaseHeight // Y-koordinat dari garis atas navbar dasar
        
        let cutoutRadius: CGFloat = 32
        // cutoutDepth adalah seberapa tinggi lengkungan menonjol ke atas DARI actualNavbarTopY
        let cutoutDepthUpwards: CGFloat = 28

        guard tabCount > 0 else { return path } //
        let tabWidth = rect.width / tabCount //
        let circleCenterX = tabWidth * circlePosition + tabWidth / 2 //
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY)) // Mulai dari kiri bawah
        path.addLine(to: CGPoint(x: rect.minX, y: actualNavbarTopY)) // Garis vertikal ke atas sampai dasar navbar
        
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
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Garis vertikal ke kanan bawah
        path.closeSubpath() // Menutup ke titik awal (kiri bawah)
        return path //
    }
}

#Preview("AnimatedNavbar_LayoutFix_Final") { //
    let previewUserSession = UserSession() //
    let previewCartViewModel = CartViewModel(userSession: previewUserSession)

    return AnimatedNavbar() //
        .environmentObject(previewUserSession) //
        .environmentObject(previewCartViewModel)
}
