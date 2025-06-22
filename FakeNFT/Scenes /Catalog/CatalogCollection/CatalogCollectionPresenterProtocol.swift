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
    func configure(cell: CatalogCollectionCell, at index: Int)
    func didTapAuthor()
}
