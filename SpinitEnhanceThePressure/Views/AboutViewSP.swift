import SwiftUI

struct AboutViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "About", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(spacing: 32) {
                        Image("mainLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                            .offset(x: -8, y: 8)
                        
                        VStack(spacing: 8) {
                            Text("SPINIT")
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                            
                            Text("Enhance the Pressure")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.top, 4)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About This App")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Spinit: Enhance the Pressure is your comprehensive guide to understanding everything about football balls. From pressure management to material selection, we help you master every aspect of ball care and performance.")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                            
                            Text("Whether you're a professional player, coach, or enthusiast, our detailed articles and step-by-step tasks will enhance your knowledge and improve your game.")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
                        )
                        
                        VStack(spacing: 12) {
                            InfoRowSP(label: "Total Articles", value: "20+")
                            InfoRowSP(label: "Total Tasks", value: "20+")
                            InfoRowSP(label: "Categories", value: "8")
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 32)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct InfoRowSP: View {
    let label: String
    let value: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
        }
    }
}

#Preview {
    NavigationStack {
        AboutViewSP()
            .environmentObject(MainViewModelSP())
    }
}
