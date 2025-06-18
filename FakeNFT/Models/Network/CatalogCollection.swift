//
//  CatalogCollection.swift
//  FakeNFT
//
//  Created by Olya on 10.06.2025.
//

import Foundation

struct CatalogCollection: Decodable {
    let id: UUID
    let cover: String
    let name: String
    let nfts: [String]
    let description: String
}
