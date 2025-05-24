import SwiftUI
struct AnimatedNavbar: View {
    @Namespace var animation
    @State private var selectedTab: Tab = .home
    @State private var circlePosition: CGFloat = 0
    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case progress = "chart.bar.fill"
        case chat = "message.fill"
        case profile = "person.fill"
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6).ignoresSafeArea()
            VStack {
                Spacer()
                ZStack {
                    NavbarBackgroundShape(circlePosition: circlePosition)
                        .fill(Color.blue)
                        .frame(height: 80)
                        .animation(.easeInOut(duration: 0.4), value: circlePosition)
                    HStack(spacing: 0) {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            Spacer()
                            VStack {
                                ZStack {
                                    if selectedTab == tab {
                                        Circle()
                                            .fill(.white)
                                            .matchedGeometryEffect(id: "circle", in: animation)
                                            .frame(width: 65, height: 65)
                                            .offset(y: -15)
                                        Image(systemName: tab.rawValue)
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                            .offset(y: -15)
                                            .transition(.scale(scale: 0.5, anchor: .bottom).combined(with: .opacity))
                                    } else {
                                        Image(systemName: tab.rawValue)
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .transition(.opacity)
                                    }
                                }
                            }
                            .frame(width: 70, height: 80)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    selectedTab = tab
                                    circlePosition = CGFloat(tab.index)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                circlePosition = CGFloat(selectedTab.index)
            }
        }
    }
}
extension AnimatedNavbar.Tab {
    var index: Int {
        switch self {
        case .home: return 0
        case .progress: return 1
        case .chat: return 2
        case .profile: return 3
        }
    }
}
struct NavbarBackgroundShape: Shape {
    var circlePosition: CGFloat
    var animatableData: CGFloat {
        get { circlePosition }
        set { circlePosition = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cutoutRadius: CGFloat = 80
        let cutoutDepth: CGFloat = 60
        let cornerRadius: CGFloat = 2
        let tabWidth = rect.width / CGFloat(AnimatedNavbar.Tab.allCases.count)
        let circleCenterX = tabWidth * circlePosition + tabWidth / 2
        let cutoutStart = circleCenterX - cutoutRadius
        let cutoutEnd = circleCenterX + cutoutRadius
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90), endAngle: .degrees(180), clockwise: true)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: cutoutStart, y: rect.minY))
        let controlPoint1 = CGPoint(x: cutoutStart + cutoutRadius * 0.6, y: rect.minY)
        let midPoint = CGPoint(x: circleCenterX, y: rect.minY + cutoutDepth)
        let controlPoint2 = CGPoint(x: circleCenterX - cutoutRadius * 0.6, y: rect.minY + cutoutDepth)
        path.addCurve(to: midPoint, control1: controlPoint1, control2: controlPoint2)
        let controlPoint3 = CGPoint(x: circleCenterX + cutoutRadius * 0.6, y: rect.minY + cutoutDepth)
        let controlPoint4 = CGPoint(x: cutoutEnd - cutoutRadius * 0.6, y: rect.minY)
        path.addCurve(to: CGPoint(x: cutoutEnd, y: rect.minY), control1: controlPoint3, control2: controlPoint4)
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.closeSubpath()
        return path
    }
}
#Preview {
    AnimatedNavbar()
}
