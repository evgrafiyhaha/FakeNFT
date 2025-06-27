//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Galina evdokimova on 27.06.2025.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var httpMethod: HttpMethod = .put

    var endpoint: URL?
//    var dto: Encodable?
    var httpBody: String?
    
    init(_ httpBody: String) {
        guard let endpoint = URL(string: "\(NetworkConstants.baseURL)/api/v1/profile/1") else { return }
        self.endpoint = endpoint
        self.httpBody = httpBody
        
    }
}
