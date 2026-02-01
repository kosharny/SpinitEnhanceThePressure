import SwiftUI
import StoreKit

struct ThemeSP: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let isPremium: Bool
    let productID: String?
    
    var primaryColor: Color {
        switch id {
        case "neon_green":
            return Color(hex: "39FF14")
        case "electric_lime":
            return Color(hex: "CCFF00")
        case "soft_glow":
            return Color(hex: "A066FF")
        default:
            return Color(hex: "39FF14")
        }
    }
    
    var accentColor: Color {
        switch id {
        case "neon_green":
            return Color(hex: "2EEB5A")
        case "electric_lime":
            return Color(hex: "00FF95")
        case "soft_glow":
            return Color(hex: "FF2E63")
        default:
            return Color(hex: "2EEB5A")
        }
    }
    
    var backgroundColor: Color {
        Color(hex: "0B1A12")
    }
    
    var mutedColor: Color {
        Color(hex: "2A3A32")
    }
    
    static let allThemes: [ThemeSP] = [
        ThemeSP(id: "neon_green", name: "Neon Green", isPremium: false, productID: nil),
        ThemeSP(id: "electric_lime", name: "Electric Lime", isPremium: true, productID: "premium_theme_electric"),
        ThemeSP(id: "soft_glow", name: "Soft Glow", isPremium: true, productID: "premium_theme_softglow")
    ]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Product {
    var priceString: String {
        displayPrice
    }
}
