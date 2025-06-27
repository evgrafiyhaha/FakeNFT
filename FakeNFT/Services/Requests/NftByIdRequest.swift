import Foundation

struct NFTRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var httpMethod: HttpMethod = .get
    
//    var dto: Encodable?
    
    var httpBody: String?
    
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
