//
//  CatalogCollectionPresenterProtocol.swift
//  FakeNFT
//
//  Created by Olya on 22.06.2025.
//

import Foundation

protocol CatalogCollectionPresenterProtocol: AnyObject{
    var numberOfItems: Int { get }
    func viewDidLoad()
    func didTapAuthor()
    func reloadCart(model: CatalogCollectionCellModel)
    func reloadLike(model: CatalogCollectionCellModel)
    func configureCell(cell: CatalogCollectionCell, indexPath: IndexPath)
}
