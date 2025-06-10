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
        URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections")
    }
    
    var httpMethod: HttpMethod = .get
}
