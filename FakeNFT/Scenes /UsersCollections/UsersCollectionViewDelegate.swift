import Foundation

protocol UsersCollectionViewDelegate: AnyObject {
    func updateCollectionView()
    func reloadItems(index: IndexPath)
}
