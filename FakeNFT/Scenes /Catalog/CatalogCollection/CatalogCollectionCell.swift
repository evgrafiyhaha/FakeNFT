//
//  CatalogCollectionCell.swift
//  FakeNFT
//
//  Created by Olya on 17.06.2025.
//

import UIKit
import ProgressHUD

protocol CellDelegate: AnyObject {
    func reloadCart(model: CatalogCollectionCellModel)
    func reloadLike(model: CatalogCollectionCellModel)
}

final class CatalogCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "catalogCollectionCellIdentifier"
    
    weak var delegate: CellDelegate?
    
    private var model: CatalogCollectionCellModel?
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    private func setupUI(){
        
        [nameLabel, image, likeButton, ratingStackView, priceLabel, indicator, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 108),
            
            ratingStackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            nameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            nameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            cartButton.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 24),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    private func setRating(isFull: Bool) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = isFull ? .yellow : UIColor(named: "nftLightGray")
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        ratingStackView.addArrangedSubview(imageView)
        
    }
    
    func configure(model: CatalogCollectionCellModel) {
        self.model = model
        image.kf.setImage(with: model.images.first)
        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        for star in 1...5 {
            star <= model.rating ? setRating(isFull: true) : setRating(isFull: false)
        }
        cartButton.setImage(model.isOrders ? UIImage(named: "cartDelete") : UIImage(named: "cartEmpty"), for: .normal)
        likeButton.setImage(model.isLikes ? UIImage(named: "likeButton_on") : UIImage(named: "likeButton_off") , for: .normal)
    }
    
    func startAnimation(){
        image.isHidden = true
        indicator.startAnimating()
    }
    
    func stopAnimation() {
        image.isHidden = false
        indicator.stopAnimating()
    }
    
    @objc private func didTapLikeButton(){
        guard let model else {return}
        delegate?.reloadLike(model: model)
    }
    
    @objc private func didTapCartButton(){
        guard let model else {return}
        delegate?.reloadCart(model: model)
    }
    
    
}
