import Foundation

protocol CurrencyPresenterProtocol {
    func viewDidLoad()
    func pay()
}

final class CurrencyPresenter:CurrencyPresenterProtocol {

    weak var view: CurrencyViewProtocol?
    private let networkService: NetworkClient
    private var nfts: [Nft]
    private var onSuccess: () -> Void

    init(
        view: CurrencyViewProtocol,
        nfts: [Nft] = [],
        onSuccess: @escaping () -> Void,
        networkService: NetworkClient = DefaultNetworkClient()
    ) {
        self.view = view
        self.nfts = nfts
        self.onSuccess = onSuccess
        self.networkService = networkService
    }

    func viewDidLoad() {
        fetchCollections()
    }

    func pay() {
        let ids = nfts.map({$0.id})
        payNext(ids: ids)
    }

    private func payNext(ids: [String]) {
        guard let id = ids.first else {
            onSuccess()
            view?.presentSuccessScreen()
            return
        }
        view?.showLoading()
        let dto = OrderNftDto(nfts: id)
        let request = OrderNftRequest(dto: dto)

        networkService.send(request: request, type: OrderResponse.self) { [weak self] result in
            guard let self else { return }
            self.view?.hideLoading()

            switch result {
            case .success(let result):
                print(result)
                self.payNext(ids: Array(ids.dropFirst()))
            case .failure(let error):
                print(error)
                self.view?.showRetryAlert { [weak self] in
                    self?.pay()
                }
            }
        }
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
