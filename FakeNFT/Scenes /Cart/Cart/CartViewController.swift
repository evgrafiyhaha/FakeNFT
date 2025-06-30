import UIKit

protocol CartViewProtocol: AnyObject {
    func updateNfts(with nfts: [Nft])
}

final class CartViewController: UIViewController {
    
    private var presenter: CartPresenterProtocol?
    private var nfts: [Nft] = []
    private var servicesAssembly: ServicesAssembly

    private lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            return refreshControl
        }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .filter), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(Self.didTapFilterButton), for: .touchUpInside)
        return button
    }()
    
    private var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .segmentInactive
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .segmentActive
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(Self.didTapPaymentButton), for: .touchUpInside)
        return button
    }()
    
    private var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textActive
        return label
    }()
    
    private var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .greenUniversal
        return label
    }()
    
    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textColor = .textActive
        label.font = .bodyBold
        return label
    }()
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
        self.presenter = CartPresenter(view: self, networkService: servicesAssembly.cartNetworkClient)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func reloadData() {
        let state = nfts.isEmpty
        filterButton.isHidden = state
        tableView.isHidden = state
        paymentView.isHidden = state
        emptyStateLabel.isHidden = !state
        updateTotalLabels()
        tableView.reloadData()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(filterButton)
        paymentView.addSubview(nftCountLabel)
        paymentView.addSubview(totalPriceLabel)
        paymentView.addSubview(paymentButton)
        view.addSubview(paymentView)
        view.addSubview(emptyStateLabel)
    }
    
    private func setupConstraints() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        nftCountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            filterButton.heightAnchor.constraint(equalToConstant: 42),
            filterButton.widthAnchor.constraint(equalToConstant: 42),
            
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor),
            
            paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 76),
            
            nftCountLabel.topAnchor.constraint(equalTo: paymentView.topAnchor,constant: 16),
            nftCountLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor,constant: 16),
            
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor,constant: 2),
            totalPriceLabel.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor,constant: -16),
            totalPriceLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor,constant: 16),
            
            paymentButton.heightAnchor.constraint(equalToConstant: 44),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            paymentButton.centerYAnchor.constraint(equalTo: paymentView.centerYAnchor),
            paymentButton.widthAnchor.constraint(equalToConstant: 240),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateTotalLabels() {
        nftCountLabel.text = "\(nfts.count) NFT"
        let price = nfts.reduce(into: 0) {$0 += $1.price}
        totalPriceLabel.text = String(format: "%.2f", price) + " ETH"
    }

    @objc private func handleRefresh() {
            presenter?.viewDidLoad()
        }

    @objc
    private func didTapPaymentButton() {
        let vc = CurrencyViewController(
            nfts: nfts,
            servicesAssembly: servicesAssembly
        ) { [weak self] in
            self?.nfts.removeAll()
            self?.reloadData()
        }
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .chevronBackward),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        vc.navigationItem.leftBarButtonItem?.tintColor = .segmentActive
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func didTapClose() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapFilterButton() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { _ in
            self.nfts.sort { $0.name > $1.name }
            self.reloadData()
        }
        
        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { _ in
            self.nfts.sort { $0.price > $1.price }
            self.reloadData()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.nfts.sort { $0.rating > $1.rating }
            self.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alertController.addAction(sortByNameAction)
        alertController.addAction(sortByPriceAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(with: nfts[indexPath.row],delegate: self)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: CartViewProtocol {
    func updateNfts(with nfts: [Nft]) {
        self.nfts = nfts
        refreshControl.endRefreshing()
        reloadData()
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func present(with id: String, image: UIImage) {
        let confirmVC = ConfirmDeleteViewController()
        confirmVC.modalPresentationStyle = .overFullScreen
        confirmVC.modalTransitionStyle = .crossDissolve
        confirmVC.onDelete = { [weak self] in
            guard let self = self else { return }
            self.nfts.removeAll { $0.id == id }
            self.presenter?.reloadCart(with: self.nfts.map(\.id))
        }
        confirmVC.setupImage(image)
        
        present(confirmVC, animated: true)
    }
}
