import Foundation

protocol CurrencyPresenterProtocol {
    func viewDidLoad()
}

final class CurrencyPresenter:CurrencyPresenterProtocol {
    
    weak var view: CurrencyViewProtocol?
    private let networkService: NetworkClient
    
    init(view: CurrencyViewProtocol, networkService: NetworkClient = DefaultNetworkClient()) {
        self.view = view
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        fetchCollections()
    }
    
    private func fetchCollections() {
        view?.showLoading()
        let request = CurrencyRequest()
        networkService.send(request: request, type: [Currency].self) { [weak self] result in
            guard let self else { return }
            self.view?.hideLoading()
            switch result {
            case .success(let response):
                print(response)
                self.view?.updateCurrencies(with: response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
