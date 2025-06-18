import Foundation

protocol UsersStatisticsStorage: AnyObject {
    func getAllUsers() -> [UserStatistics]
    func saveUser(_ users: [UserStatistics])
    func getUserByIndex(_ index: Int) -> UserStatistics?
    func removeData()
}

final class UsersStatisticsStorageImpl: UsersStatisticsStorage {
    private var storage: [UserStatistics] = []

    private let syncQueue = DispatchQueue(label: "sync-userStatistics-queue")
    
    func getAllUsers() -> [UserStatistics] {
        syncQueue.sync {
            storage
        }
    }
    
    func saveUser(_ users: [UserStatistics]) {
        syncQueue.async { [weak self] in
            self?.storage.append(contentsOf: users)
        }
    }
    
    func getUserByIndex(_ index: Int) -> UserStatistics? {
        storage[index]
    }
    
    func removeData() {
        storage.removeAll()
    }
}
