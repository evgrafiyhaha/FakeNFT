import Foundation

protocol NftStatisticsStorage: AnyObject {
    func getAllNft() -> [NftStatistics]
    func saveNft(_ users: NftStatistics)
    func getNftByIndex(_ index: Int) -> NftStatistics
    func removeData()
}

final class NftStatisticsStorageImpl: NftStatisticsStorage {
    private var storage: [NftStatistics] = []

    private let syncQueue = DispatchQueue(label: "sync-nftStatistics-queue")
    
    func getAllNft() -> [NftStatistics] {
        syncQueue.sync {
            storage
        }
    }
    
    func saveNft(_ nft: NftStatistics) {
        syncQueue.async { [weak self] in
            self?.storage.append(nft)
        }
    }
    
    func getNftByIndex(_ index: Int) -> NftStatistics {
        storage[index]
    }
    
    func removeData() {
        storage.removeAll()
    }
}
