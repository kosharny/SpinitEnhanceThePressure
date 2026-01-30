import SwiftUI

struct TaskDetailsViewSP: View {
    let task: TaskSP
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.dismiss) var dismiss
    
    var isFavorite: Bool {
        viewModel.userProgress.favoriteTaskIDs.contains(task.id)
    }
    
    var isStarted: Bool {
        viewModel.userProgress.startedTaskIDs.contains(task.id)
    }
    
    var isCompleted: Bool {
        viewModel.userProgress.completedTaskIDs.contains(task.id)
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Task", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Image(task.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(task.category)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(viewModel.themeManager.currentTheme.mutedColor)
                                    .cornerRadius(8)
                                
                                Text(task.difficulty)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(viewModel.themeManager.currentTheme.mutedColor.opacity(0.5))
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 12))
                                    Text("\(task.estimatedTime) min")
                                        .font(.system(size: 13))
                                }
                                .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Text(task.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(task.description)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                            
                            if isCompleted {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                    Text("Completed")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Steps (\(task.steps.count))")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            ForEach(task.steps) { step in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(viewModel.themeManager.currentTheme.primaryColor)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Text("\(step.stepNumber)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.black)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(step.title)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text(step.description.prefix(80) + "...")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.7))
                                            .lineLimit(2)
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
                                )
                            }
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.toggleFavoriteTask(task)
                            }) {
                                HStack {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    Text(isFavorite ? "Favorited" : "Favorite")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(isFavorite ? viewModel.themeManager.currentTheme.accentColor : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                                )
                            }
                            
                            if !isCompleted {
                                NavigationLink(destination: TaskStepViewSP(task: task, currentStep: viewModel.userProgress.currentTaskProgress[task.id] ?? 0)) {
                                    HStack {
                                        Image(systemName: isStarted ? "play.circle" : "play.circle.fill")
                                        Text(isStarted ? "Continue" : "Start Task")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.themeManager.currentTheme.primaryColor)
                                    )
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    if !isStarted {
                                        viewModel.startTask(task)
                                    }
                                })
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.shouldDismissToRoot) { shouldDismiss in
            if shouldDismiss {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    viewModel.shouldDismissToRoot = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailsViewSP(
            task: TaskSP(
                id: "1",
                title: "Perfect Ball Inflation",
                category: "Maintenance",
                description: "Learn proper inflation",
                imageName: "inflation",
                difficulty: "Beginner",
                estimatedTime: 15,
                steps: [],
                isFeatured: true
            )
        )
        .environmentObject(MainViewModelSP())
    }
}
