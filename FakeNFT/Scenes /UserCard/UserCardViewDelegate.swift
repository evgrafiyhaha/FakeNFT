import UIKit

protocol UserCardViewDelegate: AnyObject {
    var userAvatarImageView: UIImageView { get set }
    var userNameLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    var collectionNFTButton: UIButton { get set }
}
