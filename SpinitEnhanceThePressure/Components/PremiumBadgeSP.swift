import SwiftUI

struct PremiumBadgeSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.black.opacity(0.7))
                .blur(radius: 2)
            
            VStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                
                Text("PRO")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
            }
        }
    }
}

#Preview {
    PremiumBadgeSP()
        .frame(width: 200, height: 150)
        .environmentObject(MainViewModelSP())
}
