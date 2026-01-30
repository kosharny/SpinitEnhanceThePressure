import SwiftUI

struct PressureCalculatorGuideViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var selectedPSI: Double = 12.0
    
    private let minPSI = 8.5
    private let maxPSI = 15.6
    
    var pressureLevel: String {
        switch selectedPSI {
        case 8.5..<10.0:
            return "Low"
        case 10.0..<12.0:
            return "Medium"
        case 12.0..<14.0:
            return "High"
        default:
            return "Very High"
        }
    }
    
    var recommendation: String {
        switch selectedPSI {
        case 8.5..<10.0:
            return "Ideal for youth players and casual play. Softer feel, easier control."
        case 10.0..<12.0:
            return "Good for training and recreational matches. Balanced performance."
        case 12.0..<14.0:
            return "Professional match standard. Optimal responsiveness and flight."
        default:
            return "Maximum pressure. Very firm, best for advanced players only."
        }
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Pressure Guide", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Text("Ball Pressure Calculator")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Adjust the slider to see recommendations for different pressure levels")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 24) {
                            VStack(spacing: 12) {
                                Text(String(format: "%.1f PSI", selectedPSI))
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                                
                                Text(pressureLevel)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                                    )
                            }
                            
                            VStack(spacing: 8) {
                                Slider(value: $selectedPSI, in: minPSI...maxPSI, step: 0.1)
                                    .tint(viewModel.themeManager.currentTheme.primaryColor)
                                
                                HStack {
                                    Text("\(String(format: "%.1f", minPSI)) PSI")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%.1f", maxPSI)) PSI")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recommendation")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(recommendation)
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Pressure Guidelines")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            PressureGuidelineSP(
                                range: "8.5 - 10.0 PSI",
                                title: "Youth & Casual",
                                description: "Softer feel, easier control, safer for headers"
                            )
                            
                            PressureGuidelineSP(
                                range: "10.0 - 12.0 PSI",
                                title: "Training",
                                description: "Balanced performance for practice sessions"
                            )
                            
                            PressureGuidelineSP(
                                range: "12.0 - 13.5 PSI",
                                title: "Professional",
                                description: "Match standard, optimal responsiveness"
                            )
                            
                            PressureGuidelineSP(
                                range: "13.5 - 15.6 PSI",
                                title: "Maximum",
                                description: "Very firm, advanced players only"
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct PressureGuidelineSP: View {
    let range: String
    let title: String
    let description: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(range)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                .frame(width: 90, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
        )
    }
}

#Preview {
    NavigationStack {
        PressureCalculatorGuideViewSP()
            .environmentObject(MainViewModelSP())
    }
}
