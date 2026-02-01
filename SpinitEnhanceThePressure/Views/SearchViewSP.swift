import SwiftUI

struct SearchViewSP: View {
    @EnvironmentObject var viewModel: MainViewModelSP
    @Environment(\.navigationPath) var path
    @State private var searchText = ""
    @State private var selectedSegment = 0
    @State private var selectedCategory = "All"
    
    var categories: [String] {
        var cats = ["All"]
        if selectedSegment == 0 {
            cats += viewModel.articles.map { $0.category }.uniqued()
        } else {
            cats += viewModel.tasks.map { $0.category }.uniqued()
        }
        return cats
    }
    
    var body: some View {
        ZStack {
            GradientBackgroundSP()
            
            VStack(spacing: 0) {
                CustomHeaderSP(title: "Search", showSettings: true)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.5))
                        
                        TextField("Search...", text: $searchText)
                            .foregroundColor(.white)
                            .onChange(of: searchText) { newValue in
                                viewModel.searchQuery = newValue
                            }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                    )
                    .padding(.horizontal, 20)
                    
                    Picker("Content Type", selection: $selectedSegment) {
                        Text("Articles").tag(0)
                        Text("Tasks").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    .colorMultiply(viewModel.themeManager.currentTheme.primaryColor)
                    .onChange(of: selectedSegment) { _ in
                        selectedCategory = "All"
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(selectedCategory == category ? .black : .white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(selectedCategory == category ? viewModel.themeManager.currentTheme.primaryColor : viewModel.themeManager.currentTheme.mutedColor.opacity(0.4))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 12)
                
                ScrollView {
                    VStack(spacing: 16) {
                        if selectedSegment == 0 {
                            if filteredArticles.isEmpty {
                                EmptySearchStateSP(message: "No articles found")
                            } else {
                                ForEach(filteredArticles) { article in
                                    ArticleCardSP(article: article)
                                        .onTapGesture {
                                            path?.wrappedValue.append(.articleDetails(article.id))
                                        }
                                }
                            }
                        } else {
                            if filteredTasks.isEmpty {
                                EmptySearchStateSP(message: "No tasks found")
                            } else {
                                ForEach(filteredTasks) { task in
                                    TaskCardSP(task: task)
                                        .onTapGesture {
                                            path?.wrappedValue.append(.taskDetails(task.id))
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    var filteredArticles: [ArticleSP] {
        var results = viewModel.filteredArticles
        if selectedCategory != "All" {
            results = results.filter { $0.category == selectedCategory }
        }
        return results
    }
    
    var filteredTasks: [TaskSP] {
        var results = viewModel.filteredTasks
        if selectedCategory != "All" {
            results = results.filter { $0.category == selectedCategory }
        }
        return results
    }
}

struct EmptySearchStateSP: View {
    let message: String
    @EnvironmentObject var viewModel: MainViewModelSP
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(viewModel.themeManager.currentTheme.primaryColor.opacity(0.3))
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

#Preview {
    NavigationStack {
        SearchViewSP()
            .environmentObject(MainViewModelSP())
    }
}
