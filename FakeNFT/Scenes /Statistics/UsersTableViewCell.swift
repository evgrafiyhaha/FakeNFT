//
//  UsersTableViewCell.swift
//  FakeNFT
//
//  Created by Николай Жирнов on 10.06.2025.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    // MARK: - UI components
    
    lazy var UserBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 80)
        ])
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .mockImageUser)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var countNFTsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init

   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       
       contentView.addSubview(UserBackgroundView)
       contentView.addSubview(numberLabel)
       
       UserBackgroundView.addSubview(avatarImageView)
       UserBackgroundView.addSubview(nameLabel)
       UserBackgroundView.addSubview(countNFTsLabel)
       
       NSLayoutConstraint.activate([
        numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        numberLabel.widthAnchor.constraint(equalToConstant: 20),
        numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
        UserBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
        UserBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        UserBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        UserBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        avatarImageView.centerYAnchor.constraint(equalTo: UserBackgroundView.centerYAnchor),
        avatarImageView.leadingAnchor.constraint(equalTo: UserBackgroundView.leadingAnchor, constant: 16),
        
        nameLabel.centerYAnchor.constraint(equalTo: UserBackgroundView.centerYAnchor),
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: countNFTsLabel.leadingAnchor, constant: -8),
        
        countNFTsLabel.trailingAnchor.constraint(equalTo: UserBackgroundView.trailingAnchor, constant: -16),
        countNFTsLabel.centerYAnchor.constraint(equalTo: UserBackgroundView.centerYAnchor),
       ])
       
       selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
