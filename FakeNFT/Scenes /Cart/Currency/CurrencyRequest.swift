import Foundation

struct CurrencyRequest: NetworkRequest {
    var dto: (any Dto)?

    var endpoint: URL? {
        URL(string: RequestConstants.currenciesURL)
    }

    var httpMethod: HttpMethod = .get
}


