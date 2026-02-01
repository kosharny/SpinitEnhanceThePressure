import SwiftUI

struct TaskCompletionViewSP: View {
    let task: TaskSP
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.dismiss) var dismiss
    @Environment(\.navigationPath) var path
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 24) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Text("Task Complete!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(opacity)
                    
                    Text("You've successfully completed")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(opacity)
                    
                    Text(task.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                        .multilineTextAlignment(.center)
                        .opacity(opacity)
                }
                
                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        StatBubbleSP(
                            icon: "book.fill",
                            value: "\(viewModel.viewedArticles.count)",
                            label: "Articles"
                        )
                        
                        StatBubbleSP(
                            icon: "checkmark.circle.fill",
                            value: "\(viewModel.completedTasks.count)",
                            label: "Tasks"
                        )
                    }
                    
                    Text("Keep up the great work!")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                .opacity(opacity)
                
                Spacer()
                
                CustomButtonSP(title: "Done", style: .primary) {
//                    viewModel.shouldDismissToRoot = true
//                    dismiss()
                    withAnimation(.easeInOut(duration: 0.45)) {
                        path?.wrappedValue.removeAll()
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                .opacity(opacity)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
            }
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 1.0
            }
        }
    }
}

struct StatBubbleSP: View {
    let icon: String
    let value: String
    let label: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(width: 120, height: 120)
        .background(
            Circle()
                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
        )
    }
}

#Preview {
    NavigationStack {
        TaskCompletionViewSP(
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
