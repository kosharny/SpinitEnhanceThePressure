import SwiftUI

struct BallMaterialsViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    
    private let materials = [
        MaterialInfo(name: "Genuine Leather", description: "Traditional material offering superior feel and touch. Absorbs water and requires more maintenance.", pros: ["Best feel", "Professional quality", "Soft touch"], cons: ["Water absorption", "Higher cost", "More maintenance"]),
        MaterialInfo(name: "Synthetic Leather", description: "Modern polymer-based material that mimics leather while offering superior weather resistance.", pros: ["Water resistant", "Consistent performance", "Durable"], cons: ["Less traditional feel", "Can be expensive"]),
        MaterialInfo(name: "Polyurethane (PU)", description: "Budget-friendly option perfect for training and recreational play.", pros: ["Affordable", "Weather resistant", "Good durability"], cons: ["Firmer feel", "Less premium"])
    ]
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Ball Materials", showBackButton: true, showSettings: false)
                
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Understanding the materials used in football construction helps you make informed decisions about which ball is right for your needs.")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                            .padding(.horizontal, 20)
                        
                        ForEach(materials) { material in
                            MaterialCardSP(material: material)
                        }
                    }
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MaterialInfo: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let pros: [String]
    let cons: [String]
}

struct MaterialCardSP: View {
    let material: MaterialInfo
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(material.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor)
            
            Text(material.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Pros")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                
                ForEach(material.pros, id: \.self) { pro in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(viewModel.themeManager.currentTheme.accentColor)
                            .font(.system(size: 14))
                        Text(pro)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Cons")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red.opacity(0.8))
                
                ForEach(material.cons, id: \.self) { con in
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red.opacity(0.6))
                            .font(.system(size: 14))
                        Text(con)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.themeManager.currentTheme.backgroundColor.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(viewModel.themeManager.currentTheme.primaryColor.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    NavigationStack {
        BallMaterialsViewSP()
            .environmentObject(MainViewModelSP())
    }
}
