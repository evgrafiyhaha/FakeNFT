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
