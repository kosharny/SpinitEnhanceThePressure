import SwiftUI

struct CustomHeaderSP: View {
    let title: String
    var showBackButton: Bool = false
    var showSettings: Bool = true
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MainViewModelSP
    
    @Environment(\.navigationPath) var path
    
    var body: some View {
        HStack {
            if showBackButton {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            if showSettings {
                Button {
                    path?.wrappedValue.append(.settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                        .frame(width: 44, height: 44)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
    }
}

#Preview {
    CustomHeaderSP(title: "Home")
        .environmentObject(MainViewModelSP())
}
