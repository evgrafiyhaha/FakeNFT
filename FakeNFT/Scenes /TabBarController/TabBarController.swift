import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let statisticsTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 2
    )
  
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalogTabBarActive"),
        tag: 0

    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(resource: .basket).withTintColor(.segmentActive),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticsPresenter = StatisticsPresenter(service: servicesAssembly)
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        statisticsPresenter.delegate = statisticsController
        
        let nc = UINavigationController(rootViewController: statisticsController)
        nc.tabBarItem = statisticsTabBarItem

        let catalogController = CatalogViewController(serviceAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem

        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        let navController = UINavigationController(rootViewController: cartController)
        navController.modalPresentationStyle = .fullScreen
        navController.tabBarItem = cartTabBarItem

        viewControllers = [catalogController, navController, nc]
        tabBar.unselectedItemTintColor = .segmentActive
        view.backgroundColor = .systemBackground
    }
}
