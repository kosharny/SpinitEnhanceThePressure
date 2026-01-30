import SwiftUI

struct ArticleCardSP: View {
    let article: ArticleSP
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var isFavorite: Bool {
        viewModel.userProgress.favoriteArticleIDs.contains(article.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Image(article.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(12)
                
                Button(action: {
                    viewModel.toggleFavoriteArticle(article)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
                        .padding(10)
                        .background(Circle().fill(Color.black.opacity(0.3)))
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(article.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(viewModel.themeManager.currentTheme.mutedColor)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text("\(article.readTime) min")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(viewModel.themeManager.currentTheme.primaryColor.opacity(0.7))
                }
                
                Text(article.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(article.excerpt)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
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
    ArticleCardSP(
        article: ArticleSP(
            id: "1",
            title: "Understanding Football Ball Pressure",
            category: "Pressure",
            excerpt: "Learn the science behind optimal ball pressure",
            content: "Content here",
            imageName: "ball_pressure",
            readTime: 5,
            isFeatured: true
        )
    )
    .padding()
    .background(Color.black)
    .environmentObject(MainViewModelSP())
}
