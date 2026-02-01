import Foundation
import SwiftUI
import Combine

@MainActor
final class ThemeManagerSP: ObservableObject {
    @Published private(set) var currentTheme: ThemeSP
    
    private let themeKey = "selectedThemeID"
    private let storeManager: StoreManagerSP
    private var cancellables = Set<AnyCancellable>()
    
    init(storeManager: StoreManagerSP) {
        self.storeManager = storeManager
        
        let defaultTheme = ThemeSP.allThemes.first { !$0.isPremium }!
        let savedID = UserDefaults.standard.string(forKey: themeKey)
        
        if let id = savedID,
           let theme = ThemeSP.allThemes.first(where: { $0.id == id }) {
            self.currentTheme = theme
        } else {
            self.currentTheme = defaultTheme
        }
        
        storeManager.$isReady
            .filter { $0 }
            .sink { [weak self] _ in
                self?.syncAfterPurchase()
            }
            .store(in: &cancellables)
            
        storeManager.$purchasedProductIDs
            .sink { [weak self] _ in
                self?.syncAfterPurchase()
            }
            .store(in: &cancellables)
    }
    
    private func syncAfterPurchase() {
        guard storeManager.isReady else { return }
        
        if currentTheme.isPremium,
           let productID = currentTheme.productID,
           !storeManager.isPurchased(productID) {
            let fallback = ThemeSP.allThemes.first { !$0.isPremium }!
            currentTheme = fallback
            UserDefaults.standard.set(fallback.id, forKey: themeKey)
        }
    }
    
    func selectTheme(_ theme: ThemeSP) {
        guard isThemeUnlocked(theme.id) else { return }
        currentTheme = theme
        UserDefaults.standard.set(theme.id, forKey: themeKey)
    }
    
    func isThemeUnlocked(_ themeID: String) -> Bool {
        guard let theme = ThemeSP.allThemes.first(where: { $0.id == themeID }) else {
            return false
        }
        if !theme.isPremium { return true }
        guard let productID = theme.productID else { return false }
        return storeManager.isPurchased(productID)
    }
}

