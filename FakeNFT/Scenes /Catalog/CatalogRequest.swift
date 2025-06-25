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

struct OrderRequest: NetworkRequest {
    let newData: Orders?
    var dto: Encodable? {
        if let data = newData {
            let formData: [String: String] = [
                "nfts": !data.nfts.isEmpty ? data.nfts.joined(separator: ", ") : "null"
            ]
            return formData
        } else {
            return nil
        }
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod = .get
}

struct LikesNftRequest: NetworkRequest {
    let newData: Profile?
    var dto: Encodable? {
        if let data = newData {
            let formData: [String: String] = [
                "likes": !data.likes.isEmpty ? data.likes.joined(separator: ", ") : "null"
            ]
            return formData
        } else {
            return nil
        }
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod = .get
}
