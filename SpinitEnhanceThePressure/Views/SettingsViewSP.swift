import SwiftUI

struct SettingsViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var selectedTheme: ThemeSP?
    @State private var showPaywall = false
    @State private var isRestoring = false
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Settings", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Themes")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(ThemeSP.allThemes) { theme in
                                    ThemeCardCompactSP(theme: theme) {
                                        if theme.isPremium && !viewModel.themeManager.isThemeUnlocked(theme.id) {
                                            selectedTheme = theme
                                        } else {
                                            viewModel.themeManager.selectTheme(theme)
                                        }
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Purchases")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            CustomButtonSP(title: isRestoring ? "Restoring..." : "Restore Purchases", style: .secondary) {
                                Task {
                                    isRestoring = true
                                    await viewModel.restorePurchases()
                                    isRestoring = false
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Information")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            NavigationLink(destination: AboutViewSP()) {
                                HStack {
                                    Text("About")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedTheme) { theme in
            PaywallViewSP(theme: theme)
                .environmentObject(viewModel)
        }
    }
}

struct ThemeCardCompactSP: View {
    let theme: ThemeSP
    let onTap: () -> Void
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var isSelected: Bool {
        viewModel.themeManager.currentTheme.id == theme.id
    }
    
    var isLocked: Bool {
        theme.isPremium && !viewModel.themeManager.isThemeUnlocked(theme.id)
    }
    
    var priceText: String {
        if !theme.isPremium { return "Free" }
        return viewModel.priceForTheme(theme)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Circle()
                    .fill(theme.primaryColor)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(theme.accentColor, lineWidth: 2)
                    )
                    .overlay {
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        } else if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(theme.accentColor)
                                .font(.system(size: 24))
                                .offset(x: 20, y: -20)
                        }
                    }
                
                VStack(spacing: 4) {
                    Text(theme.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(priceText)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(isSelected ? 0.6 : 0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? viewModel.themeManager.currentTheme.primaryColor : .clear, lineWidth: 2)
                    )
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsViewSP()
            .environmentObject(MainViewModelSP())
    }
}
