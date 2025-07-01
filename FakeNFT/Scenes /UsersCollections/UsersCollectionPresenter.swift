import UIKit
import Kingfisher

final class UsersCollectionPresenter {
    let service: ServicesAssembly
    let user: UserStatistics
    
    weak var delegate: UsersCollectionViewDelegate?
    
    var countOfNft: Int {
        service.nftStatisticsService.storage.getAllNft().count
    }
    
    var likesAndItemsInCartIsLoaded: Bool {
        let likesLoaded = service.nftStatisticsService.likesStorage.isLoaded
        let itemsInCartLoaded = service.nftStatisticsService.itemsInCartStorage.isLoaded
        return likesLoaded || itemsInCartLoaded
    }
    
    private var nftStatisticsServiceObserver: NSObjectProtocol?
    
    // MARK: - Init
    
    init(service: ServicesAssembly, user: UserStatistics) {
        self.service = service
        self.user = user
        
        nftStatisticsServiceObserver = NotificationCenter.default.addObserver(
            forName: NftStatisticsServiceImpl.didChangeNotification,
            object: nil, queue: .main)
        { [weak self] _ in
            if (self?.user.nfts.count == self?.countOfNft) && (self?.likesAndItemsInCartIsLoaded == true) {
                self?.delegate?.updateCollectionView()
            }
        }
    }
    
    // MARK: - Functions for storage
    
    func getUserByIndex(_ index: Int) -> NftStatistics {
        service.nftStatisticsService.storage.getNftByIndex(index)
    }
    
    func loadData() {
        for nftId in user.nfts {
            service.nftStatisticsService.fetchNftById(id: nftId)
        }
    }
    
    func loadLikesAndItmesInCart() {
        if !likesAndItemsInCartIsLoaded {
            service.nftStatisticsService.fetchLikes()
            service.nftStatisticsService.fetchItemsInCart()
        }
    }
    
    func removeData() {
        service.nftStatisticsService.storage.removeData()
    }
    
    // MARK: - Handle tapped Cell
    
    func tappedLike(cell: UsersCollectionViewCell) {
        guard let index = cell.indexPath else { return }
        let nft = service.nftStatisticsService.storage.getNftByIndex(index.row)
        if service.nftStatisticsService.IsNftLiked(nft.id) {
            service.nftStatisticsService.likesStorage.removeLike(nft.id)
        } else {
            service.nftStatisticsService.likesStorage.addLike(nft.id)
        }
        service.nftStatisticsService.tappedLike { [weak self] (result: Result<ChangeLikesPutResponse, Error>) in
            switch result {
            case .success(_):
                self?.delegate?.reloadItems(index: index)
                cell.likeButton.isEnabled = true
            case .failure(_):
                print("Ошибка при проставлении лайка")
            }
        }
    }
    
    func tappedChangeCart(cell: UsersCollectionViewCell) {
        guard let index = cell.indexPath else { return }
        let nft = service.nftStatisticsService.storage.getNftByIndex(index.row)
        if service.nftStatisticsService.IsNftInCart(nft.id) {
            service.nftStatisticsService.itemsInCartStorage.removeItem(nft.id)
        } else {
            service.nftStatisticsService.itemsInCartStorage.addItem(nft.id)
        }
        service.nftStatisticsService.tappedChangeCart { [weak self] (result: Result<ChangeItemsInCartPutResponse, Error>) in
            switch result {
            case .success(_):
                self?.delegate?.reloadItems(index: index)
                cell.addCartButton.isEnabled = true
            case .failure(_):
                print("Ошибка при изменении корзины")
            }
        }
    }
    
    // MARK: - ConfigureCell
    
    @MainActor
    func configureCell(_ cell: UsersCollectionViewCell, at indexPath: IndexPath) {
        cell.presenter = self
        let nft = getUserByIndex(indexPath.row)
        cell.imageView.kf.cancelDownloadTask()
        cell.activityIndicator.startAnimating()
        
        var imageURL: URL? = nil
        if let urlString = nft.images.first {
            imageURL = URL(string: urlString)
        }
        
        cell.imageView.kf.setImage(with: imageURL) { result in
            cell.activityIndicator.stopAnimating()
        }
        if service.nftStatisticsService.IsNftLiked(nft.id) {
            cell.likeButton.tintColor = UIColor(resource: .like)
        } else {
            cell.likeButton.tintColor = .white
        }
        
        if service.nftStatisticsService.IsNftInCart(nft.id) {
            cell.addCartButton.imageView?.image = UIImage(resource: .deleteCart)
        } else {
            cell.addCartButton.imageView?.image = UIImage(resource: .addCart)
        }
        cell.setupRating(nft.rating)
        cell.nameLabel.text = nft.name
        cell.priceLabel.text = "\(nft.price) ETH"
    }
}
