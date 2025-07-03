//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Olya on 11.06.2025.
//

import Foundation

protocol CatalogPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class CatalogPresenter: CatalogPresenterProtocol {
    
    weak var view: CatalogViewProtocol?
    private let networkService: NetworkClient
    
    init(view: CatalogViewProtocol, networkService: NetworkClient = DefaultNetworkClient()) {
        self.view = view
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        fetchCollections()
    }
    
    private func fetchCollections() {
        view?.showLoading()
        let request = CatalogRequest()
        networkService.send(request: request, type: [CatalogCollection].self) { [weak self] result in
            guard let self else { return }
            self.view?.hideLoading()
            switch result {
            case .success(let collections):
                self.view?.updateCollections(collections)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
