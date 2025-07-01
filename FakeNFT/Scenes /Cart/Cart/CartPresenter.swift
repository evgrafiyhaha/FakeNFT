import Foundation

protocol CartPresenterProtocol {
    func viewDidLoad()
    func reloadCart(with nfts: [String])
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartViewProtocol?
    private let networkService: NetworkClient
    
    init(view: CartViewProtocol, networkService: NetworkClient = DefaultNetworkClient()) {
        self.view = view
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        fetchCollections()
    }
    
    private func fetchCollections() {
        let request = CartRequest()
        networkService.send(request: request, type: OrderResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.fetchNfts(with: response.nfts)
            case .failure(let error):
                print("ошибка: \(error)")
            }
        }
    }

    private func fetchNfts(with ids: [String]) {
        let dispatchGroup = DispatchGroup()
        var fetchedNfts: [Nft] = []
        var fetchErrors: [Error] = []

        for id in ids {
            dispatchGroup.enter()
            let request = NFTRequest(id: id)
            networkService.send(request: request, type: Nft.self) { result in
                switch result {
                case .success(let nft):
                    fetchedNfts.append(nft)
                case .failure(let error):
                    fetchErrors.append(error)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            if !fetchErrors.isEmpty {
                print("Некоторые запросы не удались: \(fetchErrors)")
            }
            self.view?.updateNfts(with: fetchedNfts)
        }
    }

    func reloadCart(with nfts: [String]) {

        let request = OrderRequest(newData: Orders(nfts: nfts), httpMethod: .put)
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: Orders.self) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.fetchNfts(with: response.nfts)
            case .failure(let error):
                print(error)
            }
        }
    }
}
