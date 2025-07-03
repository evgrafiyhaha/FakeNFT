import UIKit
import ProgressHUD

final class UsersCollectionViewController: UIViewController {
    
    var presenter: UsersCollectionPresenter?
    
    private let widthCell = (UIScreen.main.bounds.width - 32 - 18) / 3
    private let heightCell: CGFloat = 192
    
    // MARK: - UI components
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .userCardBackButton), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24),
        ])
        return button
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UsersCollectionViewCell.self, forCellWithReuseIdentifier: "nftStatisticsCell")
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    init(presenter: UsersCollectionPresenter?) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ProgressHUD.dismiss()
        presenter?.removeData()
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "Коллекция NFT"
        
        view.addSubview(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if presenter?.countOfNft == 0 {
            presenter?.loadData()
            presenter?.loadLikesAndItemsInCart()
            ProgressHUD.animate()
        }
    }
    
    // MARK: - @objc functions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
}

// MARK: - UICollectionViewDataSource

extension UsersCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.countOfNft ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nftStatisticsCell", for: indexPath) as? UsersCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        cell.indexPath = indexPath
        presenter?.configureCell(cell, at: indexPath)
        return cell
    }
}

// MARK: - UsersCollectionViewDelegate

extension UsersCollectionViewController: UsersCollectionViewDelegate {
    func reloadItems(index: IndexPath) {
        nftCollectionView.reloadItems(at: [index])
    }
    
    func updateCollectionView() {
        nftCollectionView.reloadData()
        ProgressHUD.dismiss()
    }
}
