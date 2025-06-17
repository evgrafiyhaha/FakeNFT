import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let statisticsPresenter = StatisticsPresenter(service: servicesAssembly)
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        statisticsPresenter.delegate = statisticsController
        
        catalogController.tabBarItem = catalogTabBarItem
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [catalogController, statisticsController]

        view.backgroundColor = .systemBackground
    }
}
