import Foundation

struct ChangeItemsInCartPutRequest: NetworkRequest {
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto? {
        ChangeItemsInCartDtoObject(nfts: nfts)
    }
}

struct ChangeItemsInCartDtoObject: Dto {
   let nfts: [String]

    func asDictionary() -> [String:String] {
        [
            "nfts": nfts.isEmpty ? "null" : nfts.joined(separator: ", ")
        ]
    }
}

struct ChangeItemsInCartPutResponse: Decodable {
    let id: String
    let nfts: [String]
}
