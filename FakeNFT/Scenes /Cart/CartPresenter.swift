import UIKit

protocol CartPresenterProtocol {
    func viewDidLoad()
}

final class CartPresenter {
    
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
        networkService.send(request: request, type: CartResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.view?.updateNfts(with: response.nfts)
            case .failure(let error):
                print(error)
            }
        }
    }
}
