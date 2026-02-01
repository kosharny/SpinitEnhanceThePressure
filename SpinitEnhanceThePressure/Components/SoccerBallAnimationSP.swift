import SwiftUI

struct SoccerBallAnimationSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    
    @State private var isAnimating: Bool = false
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        let theme = viewModel.themeManager.currentTheme
        
        ZStack {
            BackgroundLayer(theme: theme, isAnimating: isAnimating)
            
            ZStack {
                OrbitRing(color: theme.primaryColor, width: 200, height: 100, rotationSpeed: 8, isAnimating: isAnimating)
                    .rotationEffect(.degrees(45))
                
                OrbitRing(color: theme.accentColor, width: 200, height: 100, rotationSpeed: -10, isAnimating: isAnimating)
                    .rotationEffect(.degrees(-45))
            }
            .opacity(0.3)
            
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 80, height: 80)
                        .blur(radius: 30)
                        .opacity(isAnimating ? 0.6 : 0.3)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                    
                    Image(systemName: "soccerball")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, theme.primaryColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .rotation3DEffect(
                            .degrees(isAnimating ? 360 : 0),
                            axis: (x: 1, y: 0.5, z: 0)
                        )
                        .shadow(color: theme.primaryColor.opacity(0.5), radius: 10, x: 0, y: 5)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.white.opacity(0.6), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                }
                .offset(y: floatOffset)
                
                Ellipse()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 60, height: 10)
                    .scaleEffect(x: isAnimating ? 0.6 : 1.0, y: isAnimating ? 0.6 : 1.0)
                    .opacity(isAnimating ? 0.1 : 0.4)
                    .blur(radius: 4)
                    .offset(y: 40)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [theme.primaryColor.opacity(0.5), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Вращение мяча (линейное, бесконечное)
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            isAnimating = true
        }
        
        // Левитация (Floating) - вверх/вниз
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            floatOffset = -15
        }
    }
}


struct BackgroundLayer: View {
    let theme: ThemeSP
    let isAnimating: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            theme.mutedColor.opacity(0.3),
                            theme.backgroundColor.opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            GeometryReader { proxy in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [theme.primaryColor.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .position(
                        x: isAnimating ? proxy.size.width * 0.8 : proxy.size.width * 0.2,
                        y: isAnimating ? proxy.size.height * 0.2 : proxy.size.height * 0.8
                    )
            }
        }
        .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: isAnimating)
    }
}

struct OrbitRing: View {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let rotationSpeed: Double
    let isAnimating: Bool
    
    var body: some View {
        Ellipse()
            .strokeBorder(
                AngularGradient(
                    colors: [color.opacity(0), color.opacity(0.5), color.opacity(0)],
                    center: .center
                ),
                lineWidth: 2
            )
            .frame(width: width, height: height)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: abs(rotationSpeed))
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
}

#Preview {
    SoccerBallAnimationSP()
        .environmentObject(MainViewModelSP())
        .padding()
        .background(Color.black)
}
