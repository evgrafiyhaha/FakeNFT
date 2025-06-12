//
//  UsersTableViewCell.swift
//  FakeNFT
//
//  Created by Николай Жирнов on 10.06.2025.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 80)
        ])
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       
       contentView.addSubview(UserBackgroundView)
       contentView.addSubview(numberLabel)
       
       UserBackgroundView.addSubview(avatarImageView)
       UserBackgroundView.addSubview(nameLabel)
       UserBackgroundView.addSubview(ratingLabel)
       
       NSLayoutConstraint.activate([
        numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
        UserBackgroundView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 20),
        UserBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
        UserBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        UserBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        avatarImageView.topAnchor.constraint(equalTo: UserBackgroundView.topAnchor, constant: 26),
        avatarImageView.leadingAnchor.constraint(equalTo: UserBackgroundView.leadingAnchor, constant: 16),
        
        nameLabel.topAnchor.constraint(equalTo: UserBackgroundView.topAnchor, constant: 26),
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
        
        ratingLabel.trailingAnchor.constraint(equalTo: UserBackgroundView.trailingAnchor, constant: -16),
        ratingLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
        ])
       
       selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
