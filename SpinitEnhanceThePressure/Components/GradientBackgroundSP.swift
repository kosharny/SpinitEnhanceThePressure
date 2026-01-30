import SwiftUI

struct GradientBackgroundSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        LinearGradient(
            colors: [
                viewModel.themeManager.currentTheme.primaryColor.opacity(0.3),
                viewModel.themeManager.currentTheme.backgroundColor,
                .black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    GradientBackgroundSP()
        .environmentObject(MainViewModelSP())
}
