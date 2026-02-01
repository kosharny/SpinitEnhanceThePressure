import Foundation
import StoreKit
import Combine

@MainActor
final class StoreManagerSP: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isReady: Bool = false
    
    private let productIDs: Set<String> = [
        "premium_theme_electric",
        "premium_theme_softglow"
    ]
    
    private var updatesTask: Task<Void, Never>?
    
    init() {
        updatesTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await refreshPurchasedProducts()
            isReady = true
        }
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
                .sorted(by: { $0.displayName < $1.displayName })
        } catch {
            products = []
        }
    }
    
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try verify(verification)
            await transaction.finish()
            // Optimistically update immediately
            purchasedProductIDs.insert(transaction.productID) 
            await refreshPurchasedProducts()
            return true
            
        case .userCancelled, .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    func restore() async {
        await refreshPurchasedProducts()
    }
    
    func isPurchased(_ productID: String) -> Bool {
        purchasedProductIDs.contains(productID)
    }
    
    private func refreshPurchasedProducts() async {
        var purchased: Set<String> = []
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard transaction.revocationDate == nil else { continue }
            
            purchased.insert(transaction.productID)
        }
        
        purchasedProductIDs = purchased
    }
    
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached {
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else { continue }
                await transaction.finish()
                
                _ = await MainActor.run {
                    self.purchasedProductIDs.insert(transaction.productID)
                }
            }
        }
    }
    
    private func verify<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value):
            return value
        case .unverified:
            throw StoreError.failedVerification
        }
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue,
                                  shouldAddStorePayment payment: SKPayment,
                                  for product: SKProduct) -> Bool {
        return true
    }
}

enum StoreError: Error {
    case failedVerification
}
