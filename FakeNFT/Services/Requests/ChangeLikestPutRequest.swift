import Foundation

struct ChangeLikesPutRequest: NetworkRequest {
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto? {
        ChangeLikesDtoObject(likes: likes)
    }
}

struct ChangeLikesDtoObject: Dto {
   let likes: [String]

    func asDictionary() -> [String:String] {
        [
            "likes": likes.isEmpty ? "null" : likes.joined(separator: ", ")
        ]
    }
}

struct ChangeLikesPutResponse: Decodable {
    let id: String
    let likes: [String]
}

