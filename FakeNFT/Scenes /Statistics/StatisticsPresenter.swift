import UIKit
import Kingfisher

final class StatisticsPresenter {
    
    private var userStatisticsServiceObserver: NSObjectProtocol?
    
    weak var delegate: StatisticsViewControllerDelegate?
    
    var countOfUsers: Int {
        service.usersStatisticsService.storage.getAllUsers().count
    }
     
    let service: ServicesAssembly
    
    init(service: ServicesAssembly) {
        self.service = service
        
        userStatisticsServiceObserver = NotificationCenter.default.addObserver(
            forName: UserStatisticsServiceImpl.didChangeNotification,
            object: nil, queue: .main)
        { [weak self] _ in
            self?.delegate?.dataDidLoaded()
            self?.delegate?.updateUsersTable()
        }
    }
    
    func loadData() {
        delegate?.dataIsLoad()
        service.usersStatisticsService.fetchUsersNextPage()
    }
    
    func getUserByIndex(_ index: Int) -> UserStatistics? {
        service.usersStatisticsService.storage.getUserByIndex(index)
    }
    
    func loadNextPage() {
        service.usersStatisticsService.fetchUsersNextPage()
    }
    
    func filterUsers(by parameter: SortType) {
        service.usersStatisticsService.storage.removeData()
        service.usersStatisticsService.currentPage = 0
        service.usersStatisticsService.sortParameter = parameter
        delegate?.updateFullUsersTable()
        loadData()
    }
    
    @MainActor
    func configureCell(_ cell: UsersTableViewCell, at indexPath: IndexPath) {
        let user = getUserByIndex(indexPath.row)
        cell.numberLabel.text = String(indexPath.row + 1)
        cell.nameLabel.text = user?.name
        cell.countNFTsLabel.text = "\(user?.nfts.count ?? 0)"
        guard let newAvatarURL = URL(string: user?.avatar ?? "") else { return }
        cell.avatarImageView.kf.setImage(with: newAvatarURL, placeholder: UIImage(resource: .mockImageUser)) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.updateRowUsersTable(at: indexPath)
            case .failure(let error):
                print("ошибка загрузки аватарки: \(error.localizedDescription)")
            }
        }
        cell.separatorInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}

enum SortType: String {
    case name = "name"
    case rating = "rating"
}
