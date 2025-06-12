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
