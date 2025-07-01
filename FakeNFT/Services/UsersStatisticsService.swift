import Foundation

protocol UsersStatisticsService {
    var currentPage: Int { get set}
    var sortParameter: SortType? { get set }
    
    var storage: UsersStatisticsStorage { get }
    func fetchUsersNextPage()
}

final class UserStatisticsServiceImpl: UsersStatisticsService  {
    
    var storage: UsersStatisticsStorage
    
    var currentPage: Int = 0
    var sortParameter: SortType?
    
    private let networkClient: NetworkClient
    
    static let didChangeNotification = Notification.Name("UsersStatisticsServiceServiceDidChange")

    init(networkClient: NetworkClient, storage: UsersStatisticsStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func fetchUsersNextPage() {
        let request = FetchUsersRequest(page: String(currentPage), size: String(15), sortBy: sortParameter)
        networkClient.send(request: request, type: [UserStatistics].self) { [weak storage, weak self] result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let users):
                self?.currentPage += 1
                storage?.saveUser(users)
                NotificationCenter.default.post(
                    name: UserStatisticsServiceImpl.didChangeNotification,
                    object: self
                )
            }
        }
    }
    
    func getUserByIndex(_ index: Int) -> UserStatistics? {
        return storage.getUserByIndex(index)
    }
}
