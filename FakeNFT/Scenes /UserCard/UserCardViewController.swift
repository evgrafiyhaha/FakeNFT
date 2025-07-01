import UIKit
import Kingfisher

final class UserCardViewController: UIViewController, UserCardViewDelegate {
    
    let presenter: UserCardPresenter
    
    // MARK: - Inits
    
    init(presenter: UserCardPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI components
    
    lazy var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70)
        ])
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionNFTButton = createCollectionNFTButton()
    
    private lazy var backButton = createBackButton()
    private lazy var visitWebsiteButton = createVisitWebsiteButton()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        view.addSubview(userAvatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(visitWebsiteButton)
        view.addSubview(collectionNFTButton)
        
        NSLayoutConstraint.activate([
            userAvatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userAvatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41),
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            visitWebsiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            visitWebsiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            visitWebsiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionNFTButton.topAnchor.constraint(equalTo: visitWebsiteButton.bottomAnchor, constant: 56),
            collectionNFTButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionNFTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.configure()
    }
    
    // MARK: - Creating button functions
    
    private func createBackButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(resource: .userCardBackButton), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24),
        ])
        return button
    }
    
    private func createVisitWebsiteButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.addTarget(self, action: #selector(visitWebsiteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        return button
    }
    
    
    private func createCollectionNFTButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Коллекция NFT  (112)", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.backgroundColor = .systemBackground
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(collectionNFTButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
 
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 22),
            
            arrowImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return button
    }
    
    // MARK: - @objc functoins
    
    @objc private func visitWebsiteButtonTapped() {
        let vc = UserCardWebViewController()
        let webViewPresenter = UserCardWebViewPresenter(stringURL: presenter.user.website)
        webViewPresenter.delegate = vc
        vc.presenter = webViewPresenter
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func collectionNFTButtonTapped() {
        let userCollectionPresenter = UsersCollectionPresenter(service: presenter.service, user: presenter.user)
        let vc = UsersCollectionViewController(presenter: userCollectionPresenter)
        userCollectionPresenter.delegate = vc
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
