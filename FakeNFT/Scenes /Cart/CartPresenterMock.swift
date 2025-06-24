import Foundation

final class CartPresenterMock: CartPresenterProtocol {

    weak var view: CartViewProtocol?

    private let mockNfts: [Nft] = {
        func safeUrl(_ string: String) -> URL {
            guard let url = URL(string: string) else {
                fatalError("Invalid URL string: \(string)")
            }
            return url
        }

        return [
            Nft(
                id: "1",
                name: "Dominique Parks",
                rating: 2,
                images: [
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/2.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/3.png")
                ],
                price: 49.99
            ),
            Nft(
                id: "2",
                name: "Christi Noel",
                rating: 2,
                images: [
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")
                ],
                price: 36.54
            ),
            Nft(
                id: "3",
                name: "Olive Avila",
                rating: 2,
                images: [
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png")
                ],
                price: 21.0
            ),
        ]
    }()

    init(view: CartViewProtocol, networkService: NetworkClient = DefaultNetworkClient()) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchCollections()
    }
    
    private func fetchCollections() {
        view?.updateNfts(with: mockNfts)
    }
}
