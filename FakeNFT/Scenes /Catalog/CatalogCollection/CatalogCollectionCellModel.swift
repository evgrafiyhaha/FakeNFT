//
//  NFTCellModel.swift
//  FakeNFT
//
//  Created by Olya on 25.06.2025.
//

import Foundation

struct CatalogCollectionCellModel {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Double
    let indexPath: IndexPath
    let isLikes: Bool
    let isOrders: Bool

    init(nft: Nft, indexPath: IndexPath, isLikes: Bool, isOrders: Bool) {
        self.id = nft.id
        self.images = nft.images
        self.name = nft.name
        self.rating = nft.rating
        self.price = nft.price
        self.indexPath = indexPath
        self.isLikes = isLikes
        self.isOrders = isOrders
    }
}
