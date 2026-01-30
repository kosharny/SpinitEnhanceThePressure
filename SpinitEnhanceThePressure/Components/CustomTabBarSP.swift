import SwiftUI

enum TabItemSP: Int, CaseIterable {
    case home = 0
    case journal = 1
    case search = 2
    case favorites = 3
    case stats = 4
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .journal: return "book.fill"
        case .search: return "magnifyingglass"
        case .favorites: return "heart.fill"
        case .stats: return "chart.bar.fill"
        }
    }
}

struct CustomTabBarSP: View {
    @Binding var selectedTab: TabItemSP
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItemSP.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(selectedTab == tab ? .black : viewModel.themeManager.currentTheme.primaryColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            Capsule()
                                .fill(selectedTab == tab ? viewModel.themeManager.currentTheme.primaryColor : Color.clear)
                                .padding(.horizontal, 8)
                        )
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .strokeBorder(viewModel.themeManager.currentTheme.primaryColor.opacity(0.5), lineWidth: 2)
                .background(
                    Capsule()
                        .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.95))
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

#Preview {
    CustomTabBarSP(selectedTab: .constant(.home))
        .environmentObject(MainViewModelSP())
}
