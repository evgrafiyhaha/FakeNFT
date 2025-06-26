//
//  fetchUsersRequests.swift
//  FakeNFT
//
//  Created by Николай Жирнов on 13.06.2025.
//

import Foundation

struct FetchUsersRequest: NetworkRequest {
    let page: String
    let size: String
    let sortBy: SortType?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users?page=\(page)&size=\(size)\(sortBy.map { "&sortBy=\($0.rawValue)" } ?? "")")
    }
    var dto: Dto?
}
