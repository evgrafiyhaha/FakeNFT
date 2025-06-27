//
//  FileProfileRequest.swift
//  FakeNFT
//
//  Created by Galina evdokimova on 27.06.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var dto: (any Dto)?
    
    
    var httpMethod: HttpMethod = .get
    
//    var dto: Encodable?
    
    var httpBody: String?
    
    var endpoint: URL?
    
    init() {
        guard let endpoint = URL(string: "\(NetworkConstants.baseURL)/api/v1/profile/1") else { return }
        self.endpoint = endpoint
    }
}
