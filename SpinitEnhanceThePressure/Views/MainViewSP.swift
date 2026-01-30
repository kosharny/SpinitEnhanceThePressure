import SwiftUI

struct MainViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var showSplash = true
    @State private var showOnboarding = false
    @State private var selectedTab: TabItemSP = .home
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showSplash {
                    SplashViewSP()
                        .transition(.opacity)
                } else if showOnboarding {
                    OnboardingViewSP(isCompleted: $showOnboarding)
                        .transition(.opacity)
                } else {
                    mainContent
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        showSplash = false
                        if !viewModel.userProgress.hasCompletedOnboarding {
                            showOnboarding = true
                        }
                    }
                }
            }
        }
    }
    
    private var mainContent: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeViewSP()
                case .journal:
                    JournalViewSP()
                case .search:
                    SearchViewSP()
                case .favorites:
                    FavoritesViewSP()
                case .stats:
                    StatViewSP()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBarSP(selectedTab: $selectedTab)
                .padding(.horizontal, 10)
                .padding(.bottom)
        }
        .background(viewModel.themeManager.currentTheme.backgroundColor)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainViewSP()
        .environmentObject(MainViewModelSP())
}
