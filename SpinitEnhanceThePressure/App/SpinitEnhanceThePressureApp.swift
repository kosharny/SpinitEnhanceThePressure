import SwiftUI

@main
struct SpinitEnhanceThePressureApp: App {
    var body: some Scene {
        WindowGroup {
            MainViewSP()
                .environmentObject(MainViewModelSP())
        }
    }
}
