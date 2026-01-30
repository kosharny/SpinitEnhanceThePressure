import Foundation

struct UserProgressSP: Codable {
    var favoriteArticleIDs: Set<String>
    var favoriteTaskIDs: Set<String>
    var viewedArticleIDs: Set<String>
    var startedTaskIDs: Set<String>
    var completedTaskIDs: Set<String>
    var currentTaskProgress: [String: Int]
    var hasCompletedOnboarding: Bool
    var selectedThemeID: String
    var purchasedThemeIDs: Set<String>
    
    init() {
        self.favoriteArticleIDs = []
        self.favoriteTaskIDs = []
        self.viewedArticleIDs = []
        self.startedTaskIDs = []
        self.completedTaskIDs = []
        self.currentTaskProgress = [:]
        self.hasCompletedOnboarding = false
        self.selectedThemeID = "neon_green"
        self.purchasedThemeIDs = ["neon_green"]
    }
}
