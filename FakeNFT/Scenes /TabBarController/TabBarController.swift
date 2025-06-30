import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalogTabBarActive"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = CatalogViewController(serviceAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController]

        view.backgroundColor = .systemBackground
    }
}
