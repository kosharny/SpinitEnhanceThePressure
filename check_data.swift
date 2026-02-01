import Foundation

struct ArticleSP: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let category: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ArticleSP, rhs: ArticleSP) -> Bool {
        lhs.id == rhs.id
    }
}

struct TaskSP: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let category: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TaskSP, rhs: TaskSP) -> Bool {
        lhs.id == rhs.id
    }
}

func checkArticles() {
    let url = URL(fileURLWithPath: "/Users/maksimkosharny/Desktop/Developer/SpinitEnhanceThePressure/SpinitEnhanceThePressure/Resources/articles.json")
    do {
        let data = try Data(contentsOf: url)
        // Decode ignoring other fields
        struct PartialArticle: Codable {
            let id: String
        }
        let partials = try JSONDecoder().decode([PartialArticle].self, from: data)
        
        print("Loaded \(partials.count) articles")
        
        var ids = Set<String>()
        for p in partials {
            if ids.contains(p.id) {
                print("DUPLICATE ARTICLE ID: \(p.id)")
            }
            ids.insert(p.id)
        }
        
        if ids.count == partials.count {
            print("All article IDs are unique.")
        }
        
    } catch {
        print("Error reading articles: \(error)")
    }
}

func checkTasks() {
    let url = URL(fileURLWithPath: "/Users/maksimkosharny/Desktop/Developer/SpinitEnhanceThePressure/SpinitEnhanceThePressure/Resources/tasks.json")
    do {
        let data = try Data(contentsOf: url)
        struct PartialTask: Codable {
            let id: String
        }
        let partials = try JSONDecoder().decode([PartialTask].self, from: data)
        
        print("Loaded \(partials.count) tasks")
        
        var ids = Set<String>()
        for p in partials {
            if ids.contains(p.id) {
                print("DUPLICATE TASK ID: \(p.id)")
            }
            ids.insert(p.id)
        }
        
        if ids.count == partials.count {
            print("All task IDs are unique.")
        }
        
    } catch {
        print("Error reading tasks: \(error)")
    }
}

checkArticles()
checkTasks()
