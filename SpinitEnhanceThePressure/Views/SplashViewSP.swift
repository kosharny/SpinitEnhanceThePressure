import SwiftUI

struct SplashViewSP: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 20) {
                Image("mainLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .offset(x: -8, y: 8)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("SPINIT")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                    .opacity(opacity)
                
                Text("Enhance the Pressure")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashViewSP()
        .environmentObject(MainViewModelSP())
}
