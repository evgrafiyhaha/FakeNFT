import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        usersStorage: UsersStatisticsStorageImpl(),
        nftStatisticsStorage: NftStatisticsStorageImpl(),
        likesStorage: LikesStorageImpl(),
        itemsInCartStorage: ItemsInCartStorageImpl()
    )

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let tabBarController = window?.rootViewController as? TabBarController
        tabBarController?.servicesAssembly = servicesAssembly
    }
}
