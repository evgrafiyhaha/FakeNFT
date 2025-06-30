import Foundation

final class CartPresenterMock: CartPresenterProtocol {
    func reloadCart(with nfts: [String]) {
        
    }
    

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
                id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
                images: [
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/2.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/3.png")
                ], name: "Dominique Parks",
                rating: 2,
                price: 49.99
            ),
            Nft(
                id: "d6a02bd1-1255-46cd-815b-656174c1d9c0",
                images: [
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")
                ], name: "Christi Noel",
                rating: 2,
                price: 36.54
            ),
            Nft(
                id: "f380f245-0264-4b42-8e7e-c4486e237504",
                images: [
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png"),
                    safeUrl("https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png")
                ], name: "Olive Avila",
                rating: 2,
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
