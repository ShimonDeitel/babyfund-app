import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [PurchaseItem] = []
    @Published var isPro: Bool = false

    static let freeLimit = 15

    private let fileName = "babyfund_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([PurchaseItem].self, from: data) else {
            items = [
        PurchaseItem(category: "Nursery", item: "Crib", amount: 280.0),
        PurchaseItem(category: "Feeding", item: "Bottles set", amount: 34.99),
        PurchaseItem(category: "Clothing", item: "Newborn bundle", amount: 58.0)
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    @discardableResult
    func add(_ item: PurchaseItem) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: PurchaseItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: PurchaseItem) {
        items.removeAll(where: { $0.id == item.id })
        save()
    }
}
