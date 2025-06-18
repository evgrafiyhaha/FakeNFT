//
//  CatalogCollectionCell.swift
//  FakeNFT
//
//  Created by Olya on 17.06.2025.
//

import UIKit
import ProgressHUD

class CatalogCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "catalogCollectionCellIdentifier"
    
    private lazy var image: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var likeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "likeButton_on"), for: .normal)
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cartButton"), for: .normal)
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
        stack.alignment = .center
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, ratingStackView, priceLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
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
    
    private func setupUI(){
        
        [image, likeButton, cartButton,horizontalStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            horizontalStackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40)
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
    
    func configure(nft: Nft) {
        image.kf.setImage(with: nft.images.first)
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        for star in 1...5 {
            star <= nft.rating ? setRating(isFull: true) : setRating(isFull: false)
        }
        cartButton.setImage(UIImage(named: "cartEmpty"), for: .normal)
    }
    
    func startAnimation(){
        indicator.startAnimating()
    }
    
    func stopAnimation() {
        indicator.stopAnimating()
    }

}
