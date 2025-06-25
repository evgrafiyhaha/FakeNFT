//
//  CatalogCollectionPresenter.swift
//  FakeNFT
//
//  Created by Olya on 19.06.2025.
//

import Foundation
import UIKit

final class CatalogCollectionPresenter: CatalogCollectionPresenterProtocol {
    
    private weak var view: CatalogCollectionViewProtocol?
    private let catalogCollection: CatalogCollection
    private let nftService: NftService
    private let servicesAssembly: ServicesAssembly
    
    private var likesList: [String] = []
    private var ordersList: [String] = []
    
    init(view: CatalogCollectionViewProtocol? = nil, catalogCollection: CatalogCollection, nftService: NftService, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.catalogCollection = catalogCollection
        self.nftService = nftService
        self.servicesAssembly = servicesAssembly
    }
    
    var numberOfItems: Int {
        catalogCollection.nfts.count
    }
    
    func viewDidLoad() {
        if let urlStr = catalogCollection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlStr) {
            view?.showCover(url: url)
        }
        view?.showAuthor(name: catalogCollection.author)
        view?.showDescription(catalogCollection.description)
        view?.showNftsCount(catalogCollection.nfts.count)
        view?.reloadCollectionView()
        view?.showTitle(catalogCollection.name)
        
        loadLikes()
        
    }
    
    func didTapAuthor() {
        guard let url = URL(string: RequestConstants.ypURL) else {return}
        let webVC = WebViewController(url: url)
        let navVC = UINavigationController(rootViewController: webVC)
        navVC.modalPresentationStyle = .fullScreen
        (view as? UIViewController)?.present(navVC, animated: true)

    }
    
    private func loadLikes() {
        let request = LikesNftRequest(newData: nil)
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: Profile.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.likesList = profile.likes
                self.loadOrders()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    private func loadOrders() {
        let request = OrderRequest(newData: nil)
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: Orders.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.ordersList = order.nfts
                DispatchQueue.main.async {
                    self.view?.reloadCollectionView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    
    func configureCell(cell: CatalogCollectionCell, indexPath: IndexPath) {
            cell.startAnimation()
            let nftId = catalogCollection.nfts[indexPath.row]
            nftService.loadNft(id: nftId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    let model = CatalogCollectionCellModel(
                        nft: nft,
                        indexPath: indexPath,
                        isLikes: self.likesList.contains(nft.id),
                        isOrders: self.ordersList.contains(nft.id)
                    )
                    DispatchQueue.main.async {
                        cell.configure(model: model)
                        cell.stopAnimation()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        cell.stopAnimation()
                        self.view?.showError(error.localizedDescription)
                    }
                }
            }
        }
    
    func reloadCart(model: CatalogCollectionCellModel) {
        if model.isOrders {
            ordersList.removeAll { $0 == model.id }
        } else {
            ordersList.append(model.id)
        }
        let request = OrderRequest(newData: Orders(nfts: ordersList), httpMethod: .put)
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: Orders.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.ordersList = order.nfts
                DispatchQueue.main.async {
                    self.view?.updateCell(at: model.indexPath, with: model)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.view?.showError("Failed to update orders")
                }
            }
        }
    }
    
    func reloadLike(model: CatalogCollectionCellModel) {
        if model.isLikes {
            likesList.removeAll { $0 == model.id }
        } else {
            likesList.append(model.id)
        }
        let request = LikesNftRequest(newData: Profile(likes: likesList), httpMethod: .put)
        let networkService = DefaultNetworkClient()
        networkService.send(request: request, type: Profile.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.likesList = profile.likes
                DispatchQueue.main.async {
                    self.view?.updateCell(at: model.indexPath, with: model)
                }
            case .failure:
                DispatchQueue.main.async {
                    self.view?.showError("Failed to update likes")
                }
            }
        }
    }

}



