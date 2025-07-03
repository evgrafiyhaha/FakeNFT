//
//  CatalogCollectionViewProtocol.swift
//  FakeNFT
//
//  Created by Olya on 22.06.2025.
//

import Foundation

protocol CatalogCollectionViewProtocol: AnyObject {
    func showAuthor(name: String)
    func showDescription(_ description: String)
    func showCover(url: URL)
    func showNftsCount(_ count: Int)
    func showError(_ message: String)
    func reloadCollectionView()
    func showTitle(_ title: String)
    func updateCell(at indexPath: IndexPath, with model: CatalogCollectionCellModel)
}

