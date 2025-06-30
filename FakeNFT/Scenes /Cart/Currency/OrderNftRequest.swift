import Foundation

struct OrderNftRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var endpoint: URL? {
        URL(string: RequestConstants.orderURL)
    }

    var httpMethod: HttpMethod = .put
}
