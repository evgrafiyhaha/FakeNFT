import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "basket")?.withTintColor(.segmentActive),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [catalogController,cartController]
        tabBar.unselectedItemTintColor = .segmentActive
        view.backgroundColor = .systemBackground
    }
}
