//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Olya on 10.06.2025.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var endpoint: URL? {
        URL(string: RequestConstants.collectionURL)
    }
    
    var httpMethod: HttpMethod = .get
}

struct OrderDto: Dto {
    let nfts: [String]
    func asDictionary() -> [String: String] {
        ["nfts": nfts.isEmpty ? "null" : nfts.joined(separator: ", ")]
    }
}

struct LikesDto: Dto {
    let likes: [String]
    func asDictionary() -> [String: String] {
        ["likes": likes.isEmpty ? "null" : likes.joined(separator: ", ")]
    }
}

struct OrderRequest: NetworkRequest {
    let newData: Orders?
    
    var dto: Dto? {
        guard let data = newData else { return nil }
        return OrderDto(nfts: data.nfts)
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod = .get
}

struct LikesNftRequest: NetworkRequest {
    let newData: Profile?
    
    var dto: Dto? {
        guard let data = newData else { return nil }
        return LikesDto(likes: data.likes)
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod = .get
}
