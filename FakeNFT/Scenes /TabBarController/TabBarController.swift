import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileViewController = ProfileConfigurator().configure()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: nil
        )
        
    }
}
