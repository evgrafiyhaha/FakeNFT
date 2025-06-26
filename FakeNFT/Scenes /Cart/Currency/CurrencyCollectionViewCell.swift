import UIKit
import Kingfisher

final class CurrencyCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CurrencyCollectionViewCell"
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .segmentActive
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textActive
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .greenUniversal
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    func setupCell(with currency: Currency) {
        nameLabel.text = currency.name
        titleLabel.text = currency.title.replacingOccurrences(of: "_", with: " ")
        iconImageView.kf.setImage(with: currency.image)
    }
    
    func select() {
        contentView.layer.borderWidth = 1
    }
    
    func deselect() {
        contentView.layer.borderWidth = 0
    }
    
    private func setupSubviews() {
        contentView.layer.borderColor = UIColor.segmentActive.cgColor
        contentView.backgroundColor = .segmentInactive
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4)
        ])
        
    }
}
