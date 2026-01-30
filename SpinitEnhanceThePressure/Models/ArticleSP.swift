import Foundation

struct ArticleSP: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let category: String
    let excerpt: String
    let content: String
    let imageName: String
    let readTime: Int
    let isFeatured: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ArticleSP, rhs: ArticleSP) -> Bool {
        lhs.id == rhs.id
    }
}
