import SwiftUI

struct JournalViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @State private var selectedSegment = 0
    
    private let segments = ["Viewed", "Started", "Completed"]
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Journal", showSettings: true)
                
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
                            if viewModel.viewedArticles.isEmpty {
                                EmptyStateSP(message: "No articles viewed yet")
                            } else {
                                ForEach(viewModel.viewedArticles) { article in
                                    NavigationLink(value: RouteSP.articleDetails(article.id)) {
                                        ArticleCardSP(article: article)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else if selectedSegment == 1 {
                            if viewModel.startedTasks.isEmpty {
                                EmptyStateSP(message: "No tasks started yet")
                            } else {
                                ForEach(viewModel.startedTasks) { task in
                                    NavigationLink(value: RouteSP.taskDetails(task.id)) {
                                        TaskCardSP(task: task)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        } else {
                            if viewModel.completedTasks.isEmpty {
                                EmptyStateSP(message: "No tasks completed yet")
                            } else {
                                ForEach(viewModel.completedTasks) { task in
                                    NavigationLink(value: RouteSP.taskDetails(task.id)) {
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

struct EmptyStateSP: View {
    let message: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(viewModel.themeManager.currentTheme.mutedColor)
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    NavigationStack {
        JournalViewSP()
            .environmentObject(MainViewModelSP())
    }
}
