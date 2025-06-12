import Foundation
import UIKit

class StatisticsPresenter {
    
    let users = [
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
        UserStatistics(name: "Alex", image: UIImage(resource: .mockImageUser), rating: 90),
    ]
    
    let service: ServicesAssembly
    
    init(service: ServicesAssembly) {
        self.service = service
    }
    
}


struct UserStatistics {
    let name: String
    let image: UIImage
    let rating: Int
}
