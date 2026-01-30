import SwiftUI

struct StatViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var completionRate: Double {
        let total = viewModel.tasks.count
        let completed = viewModel.completedTasks.count
        return total > 0 ? Double(completed) / Double(total) : 0
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Statistics", showSettings: true)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Overall Progress")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            ZStack {
                                Circle()
                                    .stroke(viewModel.themeManager.currentTheme.mutedColor, lineWidth: 20)
                                    .frame(width: 180, height: 180)
                                
                                Circle()
                                    .trim(from: 0, to: completionRate)
                                    .stroke(
                                        viewModel.themeManager.currentTheme.primaryColor,
                                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                    )
                                    .frame(width: 180, height: 180)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack(spacing: 4) {
                                    Text("\(Int(completionRate * 100))%")
                                        .font(.system(size: 42, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Complete")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Activity Summary")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            StatRowSP(
                                icon: "book.fill",
                                title: "Articles Read",
                                value: "\(viewModel.viewedArticles.count)",
                                total: "\(viewModel.articles.count)"
                            )
                            
                            StatRowSP(
                                icon: "play.circle.fill",
                                title: "Tasks Started",
                                value: "\(viewModel.startedTasks.count)",
                                total: "\(viewModel.tasks.count)"
                            )
                            
                            StatRowSP(
                                icon: "checkmark.circle.fill",
                                title: "Tasks Completed",
                                value: "\(viewModel.completedTasks.count)",
                                total: "\(viewModel.tasks.count)"
                            )
                            
                            StatRowSP(
                                icon: "heart.fill",
                                title: "Total Favorites",
                                value: "\(viewModel.favoriteArticles.count + viewModel.favoriteTasks.count)",
                                total: nil
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            AchievementBadgeSP(
                                title: "First Steps",
                                description: "Complete your first task",
                                isUnlocked: !viewModel.completedTasks.isEmpty
                            )
                            
                            AchievementBadgeSP(
                                title: "Knowledge Seeker",
                                description: "Read 10 articles",
                                isUnlocked: viewModel.viewedArticles.count >= 10
                            )
                            
                            AchievementBadgeSP(
                                title: "Task Master",
                                description: "Complete 5 tasks",
                                isUnlocked: viewModel.completedTasks.count >= 5
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct StatRowSP: View {
    let icon: String
    let title: String
    let value: String
    let total: String?
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                if let total = total {
                    Text("\(value) / \(total)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text(value)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
        )
    }
}

struct AchievementBadgeSP: View {
    let title: String
    let description: String
    let isUnlocked: Bool
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: isUnlocked ? "star.fill" : "star")
                .font(.system(size: 32))
                .foregroundColor(isUnlocked ? viewModel.themeManager.currentTheme.accentColor : viewModel.themeManager.currentTheme.mutedColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isUnlocked ? .white : .white.opacity(0.5))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(isUnlocked ? .white.opacity(0.7) : .white.opacity(0.4))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(isUnlocked ? 0.4 : 0.2))
        )
    }
}

#Preview {
    NavigationStack {
        StatViewSP()
            .environmentObject(MainViewModelSP())
    }
}
