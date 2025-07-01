import Foundation

protocol LikesStorage: AnyObject {
    var isLoaded: Bool { get set }
    func addLikes(_ nftIds: [String])
    func addLike(_ nftId: String)
    func removeLike(_ nftId: String)
    func nftIsLiked(_ nftId: String) -> Bool
    func getLikes() -> [String]
    func removeData()
}

final class LikesStorageImpl: LikesStorage {
    var isLoaded: Bool = false 
    
    private var storage: [String] = []

    private let syncQueue = DispatchQueue(label: "sync-likesStatistics-queue")
    
    func addLike(_ nftId: String) {
        syncQueue.sync { [weak self] in
            self?.storage.append(nftId)
        }
    }
    
    func removeLike(_ nftId: String) {
        syncQueue.sync { [weak self] in
            self?.storage.removeAll { $0 == nftId }
        }
    }
    
    func nftIsLiked(_ nftId: String) -> Bool {
        storage.contains(nftId)
    }
    
    func addLikes(_ nftIds: [String]) {
        for nftId in nftIds {
            addLike(nftId)
        }
    }
    
    func getLikes() -> [String] {
        return storage
    }
    
    func removeData() {
        storage.removeAll()
    }
}
