import Foundation

final class CartPresenterMock: CartPresenterProtocol {
    
    weak var view: CartViewProtocol?
    
    init(view: CartViewProtocol, networkService: NetworkClient = DefaultNetworkClient()) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchCollections()
    }
    
    private func fetchCollections() {
        self.view?.updateNfts(with: mockNfts)
    }
}

private let mockNfts: [Nft] = [
    Nft(
        id: "1",
        name: "Dominique Parks",
        rating: 2,
        images: [
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png")!,
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/2.png")!,
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/3.png")!
        ],
        price: 49.99
    ),
    Nft(
        id: "2",
        name: "Christi Noel",
        rating: 2,
        images: [
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
        ],
        price: 36.54
    ),
    Nft(
        id: "3",
        name: "Olive Avila",
        rating: 2,
        images: [
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png")!,
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png")!,
            URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png")!
        ],
        price: 21.0
    ),
]
