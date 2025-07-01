import UIKit

final class UsersCollectionViewCell: UICollectionViewCell {
    
    weak var presenter: UsersCollectionPresenter?
    var indexPath: IndexPath?
    
    // MARK: - UI Elements
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true 
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32 - 18) / 3).isActive = true
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 18),
            button.heightAnchor.constraint(equalToConstant: 16)
        ])
        return button
    }()
    
    lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(lessThanOrEqualToConstant: 22).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addCartButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(resource: .addCart), target: self, action: #selector(handleAddCartButtonTapped))
        button.backgroundColor = .white
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 40)
        ])
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.addSubview(likeButton)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addCartButton)
        imageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            
            ratingStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: addCartButton.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: addCartButton.leadingAnchor),
            
            addCartButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            addCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        
        imageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        
        activityIndicator.stopAnimating()
        
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        likeButton.isSelected = false
        addCartButton.isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func handleLikeButtonTapped() {
        likeButton.isEnabled = false
        presenter?.tappedLike(cell: self)
    }
    
    @objc
    private func handleAddCartButtonTapped() {
        addCartButton.isEnabled = false
        presenter?.tappedChangeCart(cell: self)
    }
    
    func setupRating(_ rating: Int) {
        // Очищаем предыдущие звезды
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем новые звезды
        for i in 1...5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.tintColor = i <= rating ? .systemYellow : .systemGray3
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
            
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
}
