//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Olya on 10.06.2025.
//

import Foundation
import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
     static let reuseIdentifier = "CatalogCell"
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private lazy var image: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageURL: URL?, text: String) {
        guard let imageURL else {return}
        image.kf.setImage(with: imageURL)
        label.text = text
    }
    
    private func setupUI() {
        [label, image].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 140),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21)
        ])
        
    }
}
