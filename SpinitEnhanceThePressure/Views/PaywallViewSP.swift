import SwiftUI

struct PaywallViewSP: View {
    let theme: ThemeSP
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var isPurchasing = false
    
    var priceText: String {
        viewModel.priceForTheme(theme)
    }

    
    @State private var alertType: PaywallAlertType?
    
    enum PaywallAlertType {
        case confirmation
        case success
        case error(String)
    }

    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 16) {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(theme.accentColor, lineWidth: 3)
                        )
                        .shadow(color: theme.primaryColor.opacity(0.5), radius: 20)
                    
                    Text(theme.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Premium Theme")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack(spacing: 16) {
                    FeatureRowSP(text: "Exclusive color scheme")
                    FeatureRowSP(text: "Enhanced visual experience")
                    FeatureRowSP(text: "Support app development")
                }
                .padding(.horizontal, 40)
                
                Text(priceText)
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                
                Spacer()
                
                VStack(spacing: 12) {
                    CustomButtonSP(
                        title: isPurchasing ? "Processing..." : "Buy Now",
                        style: .premium
                    ) {
                        alertType = .confirmation
                    }
                    .disabled(isPurchasing)
                    
                    Button(action: { dismiss() }) {
                        Text("Not Now")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            
            if let type = alertType {
                switch type {
                case .confirmation:
                    CustomAlertSP(
                        title: "Confirm Purchase",
                        message: "Do you want to buy \(theme.name) for \(priceText)?",
                        primaryButtonTitle: "Buy",
                        secondaryButtonTitle: "Cancel",
                        primaryAction: {
                            Task {
                                alertType = nil // Dismiss alert to show loader/processing state if UI reflects it
                                isPurchasing = true
                                let success = await viewModel.purchaseTheme(theme)
                                isPurchasing = false
                                
                                if success {
                                    alertType = .success
                                } else {
                                    // Could refine error message if viewModel returned error details
                                    alertType = .error("Purchase could not be completed.")
                                }
                            }
                        },
                        secondaryAction: {
                            alertType = nil
                        }
                    )
                    
                case .success:
                    CustomAlertSP(
                        title: "Success!",
                        message: "You have successfully purchased \(theme.name).",
                        primaryButtonTitle: "Awesome",
                        secondaryButtonTitle: nil,
                        primaryAction: {
                            alertType = nil
                            dismiss()
                        },
                        secondaryAction: nil
                    )
                    
                case .error(let message):
                    CustomAlertSP(
                        title: "Error",
                        message: message,
                        primaryButtonTitle: "OK",
                        secondaryButtonTitle: nil,
                        primaryAction: {
                            alertType = nil
                        },
                        secondaryAction: nil
                    )
                }
            }
        }
    }
}

struct FeatureRowSP: View {
    let text: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                .font(.system(size: 20))
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    PaywallViewSP(theme: ThemeSP.allThemes[1])
        .environmentObject(MainViewModelSP())
}
