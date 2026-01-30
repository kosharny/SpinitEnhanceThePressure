import SwiftUI

struct FavoritesViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var selectedSegment = 0
    
    private let segments = ["Articles", "Tasks"]
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Favorites", showSettings: true)
                
                Picker("", selection: $selectedSegment) {
                    ForEach(0..<segments.count, id: \.self) { index in
                        Text(segments[index])
                            .tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .colorMultiply(viewModel.themeManager.currentTheme.primaryColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        if selectedSegment == 0 {
                            if viewModel.favoriteArticles.isEmpty {
                                EmptyStateSP(message: "No favorite articles yet")
                            } else {
                                ForEach(viewModel.favoriteArticles) { article in
                                    NavigationLink(destination: DetailsViewSP(article: article)) {
                                        ArticleCardSP(article: article)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else {
                            if viewModel.favoriteTasks.isEmpty {
                                EmptyStateSP(message: "No favorite tasks yet")
                            } else {
                                ForEach(viewModel.favoriteTasks) { task in
                                    NavigationLink(destination: TaskDetailsViewSP(task: task)) {
                                        TaskCardSP(task: task)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        FavoritesViewSP()
            .environmentObject(MainViewModelSP())
    }
}
