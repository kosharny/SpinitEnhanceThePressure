import Foundation
import SwiftUI
import Combine
import StoreKit

class MainViewModelSP: ObservableObject {
    @Published var articles: [ArticleSP] = []
    @Published var tasks: [TaskSP] = []
    @Published var userProgress: UserProgressSP
    @Published var searchQuery: String = ""
    @Published var showPaywall: Bool = false
    @Published var selectedThemeForPurchase: ThemeSP?
    @Published var shouldDismissToRoot: Bool = false
    
    let themeManager: ThemeManagerSP
    let storeManager: StoreManagerSP
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.storeManager = StoreManagerSP()
        self.themeManager = ThemeManagerSP(storeManager: storeManager)
        self.userProgress = UserProgressSP()
        
        // Propagate changes from dependencies
        self.storeManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
            
        self.themeManager.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
            
        loadUserProgress()
        loadArticles()
        loadTasks()
    }
    
    private func loadArticles() {
        guard let url = Bundle.main.url(forResource: "articles", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([ArticleSP].self, from: data) else {
            return
        }
        articles = decoded
    }
    
    private func loadTasks() {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([TaskSP].self, from: data) else {
            return
        }
        tasks = decoded
    }
    
    private func loadUserProgress() {
        if let data = UserDefaults.standard.data(forKey: "userProgress"),
           let decoded = try? JSONDecoder().decode(UserProgressSP.self, from: data) {
            userProgress = decoded
        }
    }
    
    private func saveUserProgress() {
        if let encoded = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(encoded, forKey: "userProgress")
        }
    }
    
    func toggleFavoriteArticle(_ article: ArticleSP) {
        if userProgress.favoriteArticleIDs.contains(article.id) {
            userProgress.favoriteArticleIDs.remove(article.id)
        } else {
            userProgress.favoriteArticleIDs.insert(article.id)
        }
        saveUserProgress()
    }
    
    func toggleFavoriteTask(_ task: TaskSP) {
        if userProgress.favoriteTaskIDs.contains(task.id) {
            userProgress.favoriteTaskIDs.remove(task.id)
        } else {
            userProgress.favoriteTaskIDs.insert(task.id)
        }
        saveUserProgress()
    }
    
    func markArticleAsViewed(_ article: ArticleSP) {
        userProgress.viewedArticleIDs.insert(article.id)
        saveUserProgress()
    }
    
    func startTask(_ task: TaskSP) {
        userProgress.startedTaskIDs.insert(task.id)
        userProgress.currentTaskProgress[task.id] = 0
        saveUserProgress()
    }
    
    func updateTaskProgress(_ task: TaskSP, step: Int) {
        userProgress.currentTaskProgress[task.id] = step
        saveUserProgress()
    }
    
    func completeTask(_ task: TaskSP) {
        userProgress.completedTaskIDs.insert(task.id)
        userProgress.currentTaskProgress.removeValue(forKey: task.id)
        saveUserProgress()
    }
    
    func completeOnboarding() {
        userProgress.hasCompletedOnboarding = true
        saveUserProgress()
    }
    
    var favoriteArticles: [ArticleSP] {
        articles.filter { userProgress.favoriteArticleIDs.contains($0.id) }
    }
    
    var favoriteTasks: [TaskSP] {
        tasks.filter { userProgress.favoriteTaskIDs.contains($0.id) }
    }
    
    var viewedArticles: [ArticleSP] {
        articles.filter { userProgress.viewedArticleIDs.contains($0.id) }
    }
    
    var startedTasks: [TaskSP] {
        tasks.filter { userProgress.startedTaskIDs.contains($0.id) }
    }
    
    var completedTasks: [TaskSP] {
        tasks.filter { userProgress.completedTaskIDs.contains($0.id) }
    }
    
    var featuredArticles: [ArticleSP] {
        articles.filter { $0.isFeatured }
    }
    
    var featuredTasks: [TaskSP] {
        tasks.filter { $0.isFeatured }
    }
    
    var filteredArticles: [ArticleSP] {
        guard !searchQuery.isEmpty else { return articles }
        return articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.category.localizedCaseInsensitiveContains(searchQuery) ||
            $0.content.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    var filteredTasks: [TaskSP] {
        guard !searchQuery.isEmpty else { return tasks }
        return tasks.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            $0.category.localizedCaseInsensitiveContains(searchQuery) ||
            $0.description.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    func purchaseTheme(_ theme: ThemeSP) async -> Bool {
        guard let productID = theme.productID,
              let product = storeManager.products.first(where: { $0.id == productID }) else {
            return false
        }
        
        do {
            let success = try await storeManager.purchase(product)
            if success {
                await Task.yield()
                themeManager.selectTheme(theme)
            }
            return success
        } catch {
            return false
        }
    }

    func restorePurchases() async {
        await storeManager.restore()
    }
    
    func priceForTheme(_ theme: ThemeSP) -> String {
        guard let productID = theme.productID,
              let product = storeManager.products.first(where: { $0.id == productID }) else {
            return "—"
        }
        return product.displayPrice
    }
}
