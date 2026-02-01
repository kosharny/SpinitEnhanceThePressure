import SwiftUI

struct HomeViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.navigationPath) var path
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Home", showSettings: true)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            ZStack(alignment: .topLeading) {
                                Image("eco_friendly_football")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 140)
                                    .clipped()
                                    .cornerRadius(12)
                                    .overlay(
                                        Color.black.opacity(0.3)
                                            .cornerRadius(12)
                                    )
                                
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                    Text("Quick Tip")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.8))
                                )
                                .padding(12)
                            }
                            
                            Text("Check your ball pressure before every match for optimal performance!")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                                .padding(.horizontal, 4)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(viewModel.themeManager.currentTheme.primaryColor.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .shadow(color: viewModel.themeManager.currentTheme.primaryColor.opacity(0.2), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Featured Articles")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                NavigationLink(value: RouteSP.articleList) {
                                    Text("See All")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.featuredArticles.prefix(5)) { article in
                                        ArticleCardSP(article: article)
                                            .frame(width: 280)
                                            .onTapGesture {
                                                path?.wrappedValue.append(.articleDetails(article.id))
                                            }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Featured Tasks")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                NavigationLink(value: RouteSP.taskList) {
                                    Text("See All")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.featuredTasks.prefix(5)) { task in
                                            TaskCardSP(task: task)
                                                .frame(width: 280)
                                                .onTapGesture {
                                                        path?.wrappedValue.append(.taskDetails(task.id))
                                                    }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Stats")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 12) {
                                StatBoxSP(
                                    title: "Articles Read",
                                    value: "\(viewModel.viewedArticles.count)",
                                    icon: "book.fill"
                                )
                                
                                StatBoxSP(
                                    title: "Tasks Done",
                                    value: "\(viewModel.completedTasks.count)",
                                    icon: "checkmark.circle.fill"
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Explore More")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            NavigationLink(value: RouteSP.ballMaterials) {
                                ExtraScreenCardSP(
                                    icon: "circle.grid.3x3.fill",
                                    title: "Ball Materials",
                                    description: "Learn about different football materials and their properties"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20)
                            
                            NavigationLink(value: RouteSP.pressureGuide) {
                                ExtraScreenCardSP(
                                    icon: "gauge",
                                    title: "Pressure Guide",
                                    description: "Interactive calculator for optimal ball pressure"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 100)
                }
                .scrollDisabled(false)
            }
        }
        .navigationBarHidden(true)
    }
}

struct StatBoxSP: View {
    let title: String
    let value: String
    let icon: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
        )
    }
}

struct ExtraScreenCardSP: View {
    let icon: String
    let title: String
    let description: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.5))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.themeManager.currentTheme.primaryColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ArticleListViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.navigationPath) var path
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "All Articles", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.articles) { article in
                            ArticleCardSP(article: article)
                                .onTapGesture {
                                    path?.wrappedValue.append(.articleDetails(article.id))
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct TaskListViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.navigationPath) var path
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "All Tasks", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.tasks) { task in
                            TaskCardSP(task: task)
                                .onTapGesture {
                                    path?.wrappedValue.append(.taskDetails(task.id))
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        HomeViewSP()
            .environmentObject(MainViewModelSP())
    }
}
