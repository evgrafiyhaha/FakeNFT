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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var authorStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorLabel, authorNameLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
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
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 8
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
        authorNameLabel.text = catalogCollection.author
    }
    
    @objc private func backButtonDidTap(){
        dismiss(animated: true)
    }
    
    private func setupUI() {
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        [collectionView, imageView, collectionLabel, descriptionLabel, authorStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            
            collectionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            collectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionLabel.heightAnchor.constraint(equalToConstant: 28),
            
            authorStackView.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 8),
            authorStackView.heightAnchor.constraint(equalToConstant: 28),
            authorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorStackView.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        let itemsCount = catalogCollection.nfts.count
        let rows = Int(ceil(Double(itemsCount) / 3.0))
        let height = CGFloat(rows) * 192 + CGFloat(rows - 1) * 8
        
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
    }
    
    private func configureCell(cell: CatalogCollectionCell, indexPath: IndexPath) {
        cell.startAnimation()
        servicesAssembly.nftService.loadNft(id: catalogCollection.nfts[indexPath.row]) { (result: Result<Nft, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    cell.configure(nft: nft)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                cell.stopAnimation()
            }
        }
        
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
        let spacing: CGFloat = 10
        let itemsPerRow: CGFloat = 3
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.frame.width - totalSpacing
        let cellWidth = floor(availableWidth / itemsPerRow)
        return CGSize(width: cellWidth, height: 192)
    }
    
    
    
}
