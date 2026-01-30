import SwiftUI

struct TaskCardSP: View {
    let task: TaskSP
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var isFavorite: Bool {
        viewModel.userProgress.favoriteTaskIDs.contains(task.id)
    }
    
    var isCompleted: Bool {
        viewModel.userProgress.completedTaskIDs.contains(task.id)
    }
    
    var progress: Double {
        if isCompleted {
            return 1.0
        }
        if let currentStep = viewModel.userProgress.currentTaskProgress[task.id] {
            return Double(currentStep + 1) / Double(task.steps.count)
        }
        return 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Image(task.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(12)
                
                Button(action: {
                    viewModel.toggleFavoriteTask(task)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                        .padding(10)
                        .background(Circle().fill(Color.black.opacity(0.3)))
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(task.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(viewModel.themeManager.currentTheme.mutedColor)
                        .cornerRadius(6)
                    
                    Text(task.difficulty)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(viewModel.themeManager.currentTheme.mutedColor.opacity(0.5))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(task.estimatedTime) min")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor.opacity(0.7))
                }
                
                Text(task.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(task.description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(isCompleted ? "Completed" : (progress > 0 ? "In Progress" : "Not Started"))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(
                                isCompleted ? viewModel.themeManager.currentTheme.accentColor :
                                (progress > 0 ? viewModel.themeManager.currentTheme.primaryColor : .white.opacity(0.5))
                            )
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(viewModel.themeManager.currentTheme.mutedColor)
                                .frame(height: 4)
                                .cornerRadius(2)
                            
                            Rectangle()
                                .fill(isCompleted ? viewModel.themeManager.currentTheme.accentColor : viewModel.themeManager.currentTheme.primaryColor)
                                .frame(width: geometry.size.width * progress, height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                }
            }
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
    }
}

#Preview {
    TaskCardSP(
        task: TaskSP(
            id: "1",
            title: "Perfect Ball Inflation",
            category: "Maintenance",
            description: "Learn the proper technique for inflating your football to the perfect pressure",
            imageName: "inflation",
            difficulty: "Beginner",
            estimatedTime: 15,
            steps: [],
            isFeatured: true
        )
    )
    .padding()
    .background(Color.black)
    .environmentObject(MainViewModelSP())
}
