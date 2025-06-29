import Foundation
import UIKit

class UsersCollectionPresenter {
    let service: ServicesAssembly
    
    weak var delegate: UsersCollectionViewDelegate?
    
    let data: [NftStatistics] = [
        NftStatistics(id: "424242", name: "Angel Alvarado", images: UIImage(resource: .mockNftStatistics), rating: 2, price: 60.9),
        NftStatistics(id: "424242", name: "Name", images: UIImage(resource: .mockNftStatistics), rating: 5, price: 60.9),
        NftStatistics(id: "424242", name: "Name", images: UIImage(resource: .mockNftStatistics), rating: 3, price: 60.9),
        NftStatistics(id: "424242", name: "Name", images: UIImage(resource: .mockNftStatistics), rating: 1, price: 60.9),
        NftStatistics(id: "424242", name: "Name", images: UIImage(resource: .mockNftStatistics), rating: 4, price: 60.9),
        NftStatistics(id: "424242", name: "Name", images: UIImage(resource: .mockNftStatistics), rating: 0, price: 60.9)
    ]
    
    var countOfUsers: Int {
        data.count
    }
    
    init(service: ServicesAssembly) {
        self.service = service
    }
    
    func getUserByIndex(_ index: Int) -> NftStatistics {
        data[index]
    }
    
    
    @MainActor
    func configureCell(_ cell: UsersCollectionViewCell, at indexPath: IndexPath) {
        let nft = getUserByIndex(indexPath.row)
        cell.setupRating(nft.rating)
        cell.nameLabel.text = nft.name
        cell.priceLabel.text = "\(nft.price) ETH"
    }
}
