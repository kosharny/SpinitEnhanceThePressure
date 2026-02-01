import SwiftUI

enum RouteSP: Hashable {
    case taskDetails(String)
    case taskStep(String)
    case taskCompletion(String)
    case articleDetails(String)
    case settings
    case articleList
    case taskList
    case ballMaterials
    case pressureGuide
    case about
}


struct MainViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var showSplash = true
    @State private var showOnboarding = false
    @State private var selectedTab: TabItemSP = .home
    @State private var path: [RouteSP] = []
    
    var body: some View {
        NavigationStack(path: $path) {
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
            .navigationDestination(for: RouteSP.self) { route in
                    switch route {
                    case .taskDetails(let taskId):
                        if let task = viewModel.tasks.first(where: { $0.id == taskId }) {
                            TaskDetailsViewSP(task: task)
                        } else {
                            Text("Task not found") // Fallback
                        }
                    case .taskStep(let taskId):
                        if let task = viewModel.tasks.first(where: { $0.id == taskId }) {
                            TaskStepViewSP(task: task)
                        }
                    case .taskCompletion(let taskId):
                        if let task = viewModel.tasks.first(where: { $0.id == taskId }) {
                            TaskCompletionViewSP(task: task)
                        }
                    case .articleDetails(let articleId):
                        if let article = viewModel.articles.first(where: { $0.id == articleId }) {
                            DetailsViewSP(article: article)
                        } else {
                            Text("Article not found")
                        }
                    case .settings:
                        SettingsViewSP()
                    case .articleList:
                        ArticleListViewSP()
                    case .taskList:
                        TaskListViewSP()
                    case .ballMaterials:
                        BallMaterialsViewSP()
                    case .pressureGuide:
                        PressureCalculatorGuideViewSP()
                    case .about:
                        AboutViewSP()
                    }
                }
        }
        .environment(\.navigationPath, $path)
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

private struct NavigationPathKey: EnvironmentKey {
    static let defaultValue: Binding<[RouteSP]>? = nil
}

extension EnvironmentValues {
    var navigationPath: Binding<[RouteSP]>? {
        get { self[NavigationPathKey.self] }
        set { self[NavigationPathKey.self] = newValue }
    }
}


#Preview {
    MainViewSP()
        .environmentObject(MainViewModelSP())
}
