import Foundation


protocol StatisticsViewControllerDelegate: AnyObject {
    func updateUsersTable()
    func dataIsLoad()
    func dataDidLoaded()
    func updateFullUsersTable()
}
