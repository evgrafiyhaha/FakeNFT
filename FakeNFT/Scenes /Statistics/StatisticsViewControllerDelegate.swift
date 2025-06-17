import Foundation


protocol StatisticsViewControllerDelegate: AnyObject {
    func updateUsersTable()
    func updateRowUsersTable(at indexPath: IndexPath)
    func dataIsLoad()
    func dataDidLoaded()
}
