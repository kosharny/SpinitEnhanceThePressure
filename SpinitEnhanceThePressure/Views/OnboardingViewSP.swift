import SwiftUI

struct OnboardingViewSP: View {
    @State private var currentPage = 0
    @Binding var isCompleted: Bool
    @EnvironmentObject var viewModel: MainViewModelSP
    
    private let pages = [
        OnboardingPage(
            imageName: "ball_pressure_guide",
            title: "Master Ball Pressure",
            description: "Learn everything about optimal football pressure for peak performance on the field"
        ),
        OnboardingPage(
            imageName: "smart_football_technology",
            title: "Track Your Progress",
            description: "Complete tasks, read articles, and watch your football knowledge grow"
        ),
        OnboardingPage(
            imageName: "complete_care",
            title: "Become an Expert",
            description: "From materials to maintenance, master every aspect of football ball care"
        )
    ]
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewModel.completeOnboarding()
                        DispatchQueue.main.async {
                            isCompleted = false
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.top, 50)
                
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Image(pages[index].imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 280, height: 280)
                                .clipped()
                                .cornerRadius(24)
                            
                            Text(pages[index].title)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(pages[index].description)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 500)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? viewModel.themeManager.currentTheme.primaryColor : viewModel.themeManager.currentTheme.mutedColor)
                            .frame(width: 10, height: 10)
                    }
                }
                
                Spacer()
                
                CustomButtonSP(
                    title: currentPage == pages.count - 1 ? "Get Started" : "Next",
                    style: .primary
                ) {
                    if currentPage == pages.count - 1 {
                        viewModel.completeOnboarding()
                        DispatchQueue.main.async {
                            isCompleted = false
                        }
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

#Preview {
    OnboardingViewSP(isCompleted: .constant(false))
        .environmentObject(MainViewModelSP())
}
