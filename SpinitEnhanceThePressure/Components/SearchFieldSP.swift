import SwiftUI

struct SearchFieldSP: View {
    @Binding var searchText: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                .font(.system(size: 18))
            
            TextField("Search articles and tasks...", text: $searchText)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor.opacity(0.7))
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(viewModel.themeManager.currentTheme.primaryColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    SearchFieldSP(searchText: .constant(""))
        .padding()
        .background(Color.black)
        .environmentObject(MainViewModelSP())
}
