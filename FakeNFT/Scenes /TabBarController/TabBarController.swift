import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let statisticsTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticsPresenter = StatisticsPresenter(service: servicesAssembly)
        let statisticsController = StatisticsViewController(presenter: statisticsPresenter)
        statisticsPresenter.delegate = statisticsController
        
        let nc = UINavigationController(rootViewController: statisticsController)
        nc.tabBarItem = statisticsTabBarItem

        viewControllers = [nc]

        view.backgroundColor = .systemBackground
    }
}
