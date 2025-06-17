final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    private let usersStorage: UsersStatisticsStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStatisticsStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
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
}
