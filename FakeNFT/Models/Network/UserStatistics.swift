import Foundation

struct UserStatistics: Decodable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, avatar, description, website, nfts
    }
}
