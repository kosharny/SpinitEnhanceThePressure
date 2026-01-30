import Foundation

struct TaskStepSP: Identifiable, Codable, Hashable {
    let id: String
    let stepNumber: Int
    let title: String
    let description: String
    let imageName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct TaskSP: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let category: String
    let description: String
    let imageName: String
    let difficulty: String
    let estimatedTime: Int
    let steps: [TaskStepSP]
    let isFeatured: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TaskSP, rhs: TaskSP) -> Bool {
        lhs.id == rhs.id
    }
}
