import SwiftUI

struct TaskStepViewSP: View {
    let task: TaskSP
//    @State var currentStep: Int
    @State private var currentStep: Int = 0
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.dismiss) var dismiss
    @State private var navigateToCompletion = false
    @Environment(\.navigationPath) var path
    
    var currentStepData: TaskStepSP? {
        task.steps.first { $0.stepNumber == currentStep + 1 }
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                HStack {
                    Color.clear.frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    Text("Step \(currentStep + 1) of \(task.steps.count)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        path?.wrappedValue.append(.settings)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
                
                HStack(spacing: 4) {
                    ForEach(0..<task.steps.count, id: \.self) { index in
                        Rectangle()
                            .fill(index <= currentStep ? viewModel.themeManager.currentTheme.primaryColor : viewModel.themeManager.currentTheme.mutedColor)
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 20)
                
                if let stepData = currentStepData {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            SoccerBallAnimationSP()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Circle()
                                        .fill(viewModel.themeManager.currentTheme.primaryColor)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Text("\(stepData.stepNumber)")
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundColor(.black)
                                        )
                                    
                                    Text(stepData.title)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text(stepData.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                            }
                            
                            HStack(spacing: 12) {
                                if currentStep > 0 {
                                    CustomButtonSP(title: "Previous", style: .secondary) {
                                        withAnimation {
                                            currentStep -= 1
                                            viewModel.updateTaskProgress(task, step: currentStep)
                                        }
                                    }
                                }
                                
                                if currentStep < task.steps.count - 1 {
                                    CustomButtonSP(title: "Next", style: .primary) {
                                        withAnimation {
                                            currentStep += 1
                                            viewModel.updateTaskProgress(task, step: currentStep)
                                        }
                                    }
                                } else {
//                                    Button(action: {
//                                        viewModel.completeTask(task)
//                                        navigateToCompletion = true
//                                    }) {
//                                        Text("Complete")
//                                            .font(.system(size: 16, weight: .bold))
//                                            .foregroundColor(.black)
//                                            .frame(maxWidth: .infinity)
//                                            .padding(.vertical, 14)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 12)
//                                                    .fill(viewModel.themeManager.currentTheme.accentColor)
//                                            )
//                                    }
                                    Button {
                                        viewModel.completeTask(task)
                                        path?.wrappedValue.append(.taskCompletion(task.id))
                                    } label: {
                                        Text("Complete")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 14)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(viewModel.themeManager.currentTheme.accentColor)
                                            )
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.shouldDismissToRoot) { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .navigationDestination(isPresented: $navigateToCompletion) {
            TaskCompletionViewSP(task: task)
        }
        .onAppear {
            currentStep = viewModel.userProgress.currentTaskProgress[task.id] ?? 0
        }
    }
}

#Preview {
    NavigationStack {
        TaskStepViewSP(
            task: TaskSP(
                id: "1",
                title: "Perfect Ball Inflation",
                category: "Maintenance",
                description: "Learn proper inflation",
                imageName: "inflation",
                difficulty: "Beginner",
                estimatedTime: 15,
                steps: [
                    TaskStepSP(id: "1", stepNumber: 1, title: "Gather Equipment", description: "Collect all necessary tools", imageName: "step1"),
                    TaskStepSP(id: "2", stepNumber: 2, title: "Check Pressure", description: "Measure current pressure", imageName: "step2")
                ],
                isFeatured: true
            )
        )
        .environmentObject(MainViewModelSP())
    }
}
