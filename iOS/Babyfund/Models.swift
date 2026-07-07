import Foundation

struct PurchaseItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var category: String
    var item: String
    var amount: Double
    var dateAdded: Date = Date()
}
