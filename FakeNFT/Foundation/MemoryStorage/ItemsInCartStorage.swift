import Foundation

protocol ItemsInCartStorage: AnyObject {
    var isLoaded: Bool { get set }
    
    func addItems(_ nftIds: [String])
    func addItem(_ nftId: String)
    func removeItem(_ nftId: String)
    func itemInCart(_ nftId: String) -> Bool
    func getItems() -> [String]
    func removeData()
}

final class ItemsInCartStorageImpl: ItemsInCartStorage {
    var isLoaded: Bool = false
    
    private var storage: [String] = []

    private let syncQueue = DispatchQueue(label: "sync-likesStatistics-queue")
    
    func addItem(_ nftId: String) {
        syncQueue.sync {
            self.storage.append(nftId)
        }
    }
    
    func removeItem(_ nftId: String) {
        syncQueue.sync {
            storage.removeAll { $0 == nftId }
        }
    }
    
    func itemInCart(_ nftId: String) -> Bool {
        return storage.contains(nftId)
    }
    
    func addItems(_ nftIds: [String]) {
        for nftId in nftIds {
            addItem(nftId)
        }
    }
    
    func getItems() -> [String] {
        return storage
    }
    
    func removeData() {
        storage.removeAll()
    }
}

