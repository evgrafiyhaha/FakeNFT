import Foundation

typealias UserStatisticsCompletion = (Result<[UserStatistics], Error>) -> Void

protocol UsersStatisticsService {
    var storage: UsersStatisticsStorage { get }
    func fetchUsersNextPage()
}

final class UserStatisticsServiceImpl: UsersStatisticsService  {
    
    var storage: UsersStatisticsStorage
    
    private var currentPage: Int = 0
    private let networkClient: NetworkClient
    
    static let didChangeNotification = Notification.Name("UsersStatisticsServiceServiceDidChange")

    init(networkClient: NetworkClient, storage: UsersStatisticsStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func fetchUsersNextPage() {
        let request = fetchUsersRequest(page: String(currentPage), size: String(15))
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
}
