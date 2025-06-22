import UIKit
import Kingfisher

final class StatisticsPresenter {
    
    weak var delegate: StatisticsViewControllerDelegate?
     
    let service: ServicesAssembly
    
    var countOfUsers: Int {
        service.usersStatisticsService.storage.getAllUsers().count
    }
    
    private var userStatisticsServiceObserver: NSObjectProtocol?
    
    // MARK: - Init
    
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
    
    // MARK: Internal functions
    
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
        removeData()
        service.usersStatisticsService.sortParameter = parameter
        loadData()
    }
    
    func refreshData() {
        removeData()
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
    
    // MARK: Private functions
    
    
    private func removeData() {
        service.usersStatisticsService.storage.removeData()
        service.usersStatisticsService.currentPage = 0
        delegate?.updateFullUsersTable()
    }
}


