import SwiftUI

struct CustomAlertSP: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Optional: dismiss on background tap if needed,
                    // but usually modal alerts require explicit action.
                }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 16) {
                    if let secondaryTitle = secondaryButtonTitle {
                        Button(action: {
                            secondaryAction?()
                        }) {
                            Text(secondaryTitle)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    
                    Button(action: {
                        primaryAction()
                    }) {
                        Text(primaryButtonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(viewModel.themeManager.currentTheme.primaryColor)
                            )
                    }
                }
                .padding(.top, 10)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1C1C1E")) // Dark background typical of iOS dark mode / app theme
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(viewModel.themeManager.currentTheme.primaryColor.opacity(0.5), lineWidth: 2)
                    )
            )
            .padding(.horizontal, 40)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .zIndex(100)
    }
}

extension View {
    func customAlertSP(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) -> some View {
        ZStack {
            self
            
            if isPresented.wrappedValue {
                CustomAlertSP(
                    title: title,
                    message: message,
                    primaryButtonTitle: primaryButtonTitle,
                    secondaryButtonTitle: secondaryButtonTitle,
                    primaryAction: {
                        primaryAction()
                        isPresented.wrappedValue = false
                    },
                    secondaryAction: {
                        secondaryAction?()
                        isPresented.wrappedValue = false
                    }
                )
            }
        }
    }
}
