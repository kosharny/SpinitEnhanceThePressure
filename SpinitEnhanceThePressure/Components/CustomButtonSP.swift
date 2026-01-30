import SwiftUI

enum ButtonStyleType {
    case primary
    case secondary
    case premium
}

struct CustomButtonSP: View {
    let title: String
    let style: ButtonStyleType
    let action: () -> Void
    
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 2)
                )
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return viewModel.themeManager.currentTheme.primaryColor
        case .secondary:
            return viewModel.themeManager.currentTheme.mutedColor
        case .premium:
            return viewModel.themeManager.currentTheme.accentColor
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .premium:
            return .black
        case .secondary:
            return viewModel.themeManager.currentTheme.primaryColor
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return viewModel.themeManager.currentTheme.accentColor
        case .secondary:
            return viewModel.themeManager.currentTheme.primaryColor.opacity(0.5)
        case .premium:
            return viewModel.themeManager.currentTheme.primaryColor
        }
    }
    
    private var shadowColor: Color {
        viewModel.themeManager.currentTheme.primaryColor.opacity(0.3)
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomButtonSP(title: "Primary Button", style: .primary, action: {})
        CustomButtonSP(title: "Secondary Button", style: .secondary, action: {})
        CustomButtonSP(title: "Premium Button", style: .premium, action: {})
    }
    .padding()
    .background(Color.black)
    .environmentObject(MainViewModelSP())
}
