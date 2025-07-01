import UIKit

protocol UsersCollectionViewDelegate: AnyObject {
    func updateCollectionView()
    func reloadItems(index: IndexPath)
}
