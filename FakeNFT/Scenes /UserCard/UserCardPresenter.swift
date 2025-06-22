import UIKit

final class UserCardPresenter {
    
    // MARK: - Internal properties
    
    weak var delegate: UserCardViewDelegate?
    
    let service: ServicesAssembly
    let index: Int
    let user: UserStatistics
    
    // MARK: - Init
    
    init(service: ServicesAssembly, index: Int) {
        self.service = service
        self.index = index
        self.user = service.usersStatisticsService.storage.getUserByIndex(index)
    }
    
    // MARK: - Internal functions
    
    func configure() {
        guard let avatarURL = URL(string: user.avatar) else { return }
        delegate?.userAvatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(resource: .mockImageUser))
        delegate?.userNameLabel.text = user.name
        delegate?.descriptionLabel.text = user.description
        delegate?.collectionNFTButton.setTitle("Коллекция NFT  (\(user.nfts.count))", for: .normal)
    }
}


