import SwiftUI

struct DetailsViewSP: View {
    let article: ArticleSP
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var isFavorite: Bool {
        viewModel.userProgress.favoriteArticleIDs.contains(article.id)
    }
    
    var isRead: Bool {
        viewModel.userProgress.viewedArticleIDs.contains(article.id)
    }
    
    var contentSections: [String] {
        article.content.components(separatedBy: "\n\n").filter { !$0.isEmpty }
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Article", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Image(article.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 220)
                            .clipped()
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(article.category)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(viewModel.themeManager.currentTheme.mutedColor)
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                HStack(spacing: 6) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 12))
                                    Text("\(article.readTime) min read")
                                        .font(.system(size: 13))
                                }
                                .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Text(article.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overview")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                            
                            Text(article.excerpt)
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Full Article")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            
                            ForEach(Array(contentSections.enumerated()), id: \.offset) { index, section in
                                VStack(alignment: .leading, spacing: 8) {
                                    if index > 0 {
                                        Divider()
                                            .background(viewModel.themeManager.currentTheme.mutedColor.opacity(0.5))
                                            .padding(.vertical, 8)
                                    }
                                    
                                    Text(section)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineSpacing(6)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.3))
                        )
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.toggleFavoriteArticle(article)
                            }) {
                                HStack {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    Text(isFavorite ? "Favorited" : "Add to Favorites")
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
                            
                            if !isRead {
                                Button(action: {
                                    viewModel.markArticleAsViewed(article)
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle")
                                        Text("Mark as Read")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.themeManager.currentTheme.primaryColor.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.themeManager.currentTheme.primaryColor, lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if !isRead {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    viewModel.markArticleAsViewed(article)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailsViewSP(
            article: ArticleSP(
                id: "1",
                title: "Understanding Football Ball Pressure",
                category: "Pressure",
                excerpt: "Learn the science",
                content: "Football ball pressure is one of the most critical yet often overlooked aspects of the game. The official FIFA regulations specify that a football should be inflated to a pressure between 8.5 and 15.6 PSI.\n\nProper pressure affects ball control, flight trajectory, and player safety. A well-inflated ball provides consistent bounce and predictable behavior during play.\n\nRegular pressure checks before matches ensure optimal performance and reduce injury risk during headers.",
                imageName: "ball",
                readTime: 5,
                isFeatured: true
            )
        )
        .environmentObject(MainViewModelSP())
    }
}
