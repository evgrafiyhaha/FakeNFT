final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    private let usersStorage: UsersStatisticsStorage
    private let nftStatisticsStorage: NftStatisticsStorage
    private let likesStorage: LikesStorage
    private let itemsInCartStorage: ItemsInCartStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStatisticsStorage,
        nftStatisticsStorage: NftStatisticsStorage,
        likesStorage: LikesStorage,
        itemsInCartStorage: ItemsInCartStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
        self.nftStatisticsStorage = nftStatisticsStorage
        self.likesStorage = likesStorage
        self.itemsInCartStorage = itemsInCartStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    lazy var usersStatisticsService: UsersStatisticsService = {
        UserStatisticsServiceImpl(
            networkClient: networkClient,
            storage: usersStorage
        )
    }()
    
    lazy var nftStatisticsService: NftStatisticsService = {
        NftStatisticsServiceImpl(
            networkClient: networkClient,
            storage: nftStatisticsStorage,
            likeStorage: likesStorage,
            itemsInCartStorage: itemsInCartStorage
        )
    }()
  
    var catalogNetworkClient: NetworkClient {
           networkClient
       }
  
    var cartNetworkClient: NetworkClient {
           networkClient
       }
}
