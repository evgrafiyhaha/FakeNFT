//
//  CatalogCollectionVC.swift
//  FakeNFT
//
//  Created by Olya on 17.06.2025.
//

import Foundation
import UIKit
import Kingfisher
import ProgressHUD

final class CatalogCollectionVC: UIViewController {
    
    private let catalogCollection: CatalogCollection
    private let servicesAssembly: ServicesAssembly
    
    private var collection: [CatalogCollection] = []
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        guard let imageURL = catalogCollection.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: imageURL) else {return image}
        image.kf.setImage(with: url)
        return image
    }()
    
    private lazy var collectionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = catalogCollection.name
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = "Автор коллекции:"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = catalogCollection.description
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(CatalogCollectionCell.self, forCellWithReuseIdentifier: CatalogCollectionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(catalogCollection: CatalogCollection, servicesAssembly: ServicesAssembly) {
        self.catalogCollection = catalogCollection
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    
     @objc private func backButtonDidTap(){
        dismiss(animated: true)
    }
    
    private func setupUI() {
        [collectionView, imageView, backButton, collectionLabel, authorLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            
            collectionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            collectionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            collectionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            collectionLabel.heightAnchor.constraint(equalToConstant: 28),
            
            authorLabel.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            authorLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            authorLabel.heightAnchor.constraint(equalToConstant: 28),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
        ])
    }
    
    private func configureCell(cell: CatalogCollectionCell, indexPath: IndexPath) {
        cell.startAnimation()
        servicesAssembly.nftService.loadNft(id: catalogCollection.nfts[indexPath.row]) { (result: Result<Nft, Error>) in
            switch result {
            case .success(let nft):
                DispatchQueue.main.async {
                    cell.configure(nft: nft)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        cell.stopAnimation()
    }
}

extension CatalogCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catalogCollection.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionCell.reuseIdentifier, for: indexPath) as? CatalogCollectionCell else {return UICollectionViewCell()}
        
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 28
        let cellWidth = width/3
        return CGSize(width: cellWidth, height: 192)
    }
    
    
}
