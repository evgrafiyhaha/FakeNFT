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
    
    init(view: CatalogCollectionViewProtocol? = nil, catalogCollection: CatalogCollection, nftService: NftService) {
        self.view = view
        self.catalogCollection = catalogCollection
        self.nftService = nftService
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
        
    }
    
    func configure(cell: CatalogCollectionCell, at index: Int) {
        cell.startAnimation()
        nftService.loadNft(id: catalogCollection.nfts[index]) { [weak cell, weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    cell?.configure(nft: nft)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
                cell?.stopAnimation()
            }
        }
    }
    
    func didTapAuthor() {
        guard let url = URL(string: RequestConstants.ypURL) else {return}
        let webVC = WebViewController(url: url)
        webVC.modalPresentationStyle = .fullScreen
        (view as? UIViewController)?.present(webVC, animated: true)
    }
    
    
}

