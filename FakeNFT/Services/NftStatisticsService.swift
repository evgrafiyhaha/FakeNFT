import Foundation

typealias likesCompletion = (Result<ChangeLikesPutResponse, Error>) -> Void
typealias ChangeCartCompletion = (Result<ChangeItemsInCartPutResponse, Error>) -> Void

protocol NftStatisticsService {
    var storage: NftStatisticsStorage { get }
    var likesStorage: LikesStorage { get }
    var itemsInCartStorage: ItemsInCartStorage { get }
    func fetchNftById(id: String)
    func getNftByIndex(_ index: Int) -> NftStatistics?
    func fetchLikes()
    func fetchItemsInCart()
    func IsNftInCart(_ nftId: String) -> Bool
    func IsNftLiked(_ nftId: String) -> Bool
    func tappedLike(completion: @escaping likesCompletion)
    func tappedChangeCart(completion: @escaping ChangeCartCompletion)
}

final class NftStatisticsServiceImpl: NftStatisticsService  {
    var storage: NftStatisticsStorage
    var likesStorage: LikesStorage
    var itemsInCartStorage: ItemsInCartStorage
    
    private let networkClient: NetworkClient
    
    static let didChangeNotification = Notification.Name("NftStatisticsServiceServiceDidChange")

    init(
        networkClient: NetworkClient,
        storage: NftStatisticsStorage,
        likeStorage: LikesStorage,
        itemsInCartStorage: ItemsInCartStorage
    ) {
        self.storage = storage
        self.networkClient = networkClient
        self.likesStorage = likeStorage
        self.itemsInCartStorage = itemsInCartStorage
    }
    
    //MARK: - GET/PUT requests
    
    func fetchNftById(id: String) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: NftStatistics.self) { [weak storage, weak self] result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let nft):
                storage?.saveNft(nft)
                NotificationCenter.default.post(
                    name: NftStatisticsServiceImpl.didChangeNotification,
                    object: self
                )
            }
        }
    }
    
    func fetchLikes() {
        let request = FetchLikesRequest()
        networkClient.send(request: request, type: LikesStatistics.self) { [weak likesStorage, weak self] result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let likes):
                likesStorage?.addLikes(likes.likes)
                likesStorage?.isLoaded = true
                NotificationCenter.default.post(
                    name: NftStatisticsServiceImpl.didChangeNotification,
                    object: self
                )
            }
        }
    }
    
    func fetchItemsInCart() {
        let request = ItemsInCartRequest()
        networkClient.send(request: request, type: ItemsInCartStatistics.self) { [weak itemsInCartStorage, weak self] result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let items):
                itemsInCartStorage?.addItems(items.nfts)
                itemsInCartStorage?.isLoaded = true
                NotificationCenter.default.post(
                    name: NftStatisticsServiceImpl.didChangeNotification,
                    object: self
                )
            }
        }
    }
    
    func tappedLike(completion: @escaping likesCompletion) {
        let request = ChangeLikesPutRequest(likes: likesStorage.getLikes())
        print(likesStorage.getLikes())
        networkClient.send(request: request, type: ChangeLikesPutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                print("Лайки успешно изменены: \(putResponse)")
                completion(.success(putResponse))
            case .failure(let error):
                print("Ошибка: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func tappedChangeCart(completion: @escaping ChangeCartCompletion) {
        let request = ChangeItemsInCartPutRequest(nfts: itemsInCartStorage.getItems())
        print(itemsInCartStorage.getItems())
        networkClient.send(request: request, type: ChangeItemsInCartPutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                print("Корзина успешно изменена: \(putResponse)")
                completion(.success(putResponse))
            case .failure(let error):
                print("Ошибка: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Functions for storage
    
    func IsNftInCart(_ nftId: String) -> Bool {
        return itemsInCartStorage.itemInCart(nftId)
    }
    
    func IsNftLiked(_ nftId: String) -> Bool {
        return likesStorage.nftIsLiked(nftId)
    }
    
    func getNftByIndex(_ index: Int) -> NftStatistics? {
        return storage.getNftByIndex(index)
    }
}
