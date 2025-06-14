import Foundation

protocol UsersStatisticsStorage: AnyObject {
    func getAllUser() -> [UserStatistics]
    func saveUser(_ users: [UserStatistics])
    func getUserByIndex(_ index: Int) -> UserStatistics?
}

final class UsersStatisticsStorageImpl: UsersStatisticsStorage {
    private var storage: [UserStatistics] = []

    private let syncQueue = DispatchQueue(label: "sync-userStatistics-queue")
    
    func getAllUser() -> [UserStatistics] {
        syncQueue.sync {
            storage
        }
    }
    
    func saveUser(_ users: [UserStatistics]) {
        syncQueue.async { [weak self] in
            users.forEach { self?.storage.append($0) }
        }
    }
    
    func getUserByIndex(_ index: Int) -> UserStatistics? {
        storage[index]
    }
}
