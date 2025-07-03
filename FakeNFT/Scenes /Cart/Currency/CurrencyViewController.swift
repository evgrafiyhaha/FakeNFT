import UIKit
import ProgressHUD

protocol CurrencyViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func updateCurrencies(with currencies: [Currency])
    func presentSuccessScreen()
    func showRetryAlert(retryAction: @escaping () -> Void)
}

final class CurrencyViewController: UIViewController {

    private var presenter: CurrencyPresenterProtocol?
    private var currencies: [Currency] = []
    private var selectedCurrency: Currency?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: CurrencyCollectionViewCell.identifier)
        return collectionView
    }()

    private lazy var paymentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .segmentInactive
        return view
    }()

    private lazy var policyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .caption2
        label.textColor = .segmentActive
        return label
    }()

    private lazy var userAgreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.setTitleColor(.blueUniversal, for: .normal)
        button.titleLabel?.font = .caption2
        button.addTarget(self, action: #selector(userAgreementButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.segmentActiveWhite, for: .normal)
        button.backgroundColor = .segmentActive.withAlphaComponent(0.3)
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(Self.paymentButtonTapped), for: .touchUpInside)
        return button
    }()

    init(
        nfts: [Nft],
        servicesAssembly: ServicesAssembly,
        onSuccess: @escaping () -> Void
    ) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = CurrencyPresenter(
            view: self,
            nfts: nfts,
            onSuccess: onSuccess,
            networkService: servicesAssembly.cartNetworkClient
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupSubviews()
        setupConstraints()
        navigationController?.navigationBar.tintColor = .segmentActive
        navigationItem.title = "Выберите способ оплаты"
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    func presentSuccessScreen() {
        let vc = SuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    func showRetryAlert(retryAction: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Не удалось произвести\nоплату",
            message: nil,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
            retryAction()
        }))

        present(alert, animated: true, completion: nil)
    }

    private func setupSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(paymentView)
        paymentView.addSubview(policyLabel)
        paymentView.addSubview(userAgreementButton)
        paymentView.addSubview(paymentButton)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        paymentView.translatesAutoresizingMaskIntoConstraints = false
        policyLabel.translatesAutoresizingMaskIntoConstraints = false
        userAgreementButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 205),

            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            policyLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            policyLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            policyLabel.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),

            userAgreementButton.topAnchor.constraint(equalTo: policyLabel.bottomAnchor),
            userAgreementButton.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),

            paymentButton.topAnchor.constraint(equalTo: userAgreementButton.bottomAnchor, constant: 16),
            paymentButton.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -12),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    @objc
    private func userAgreementButtonTapped() {
        let webViewViewController = WebViewViewController()
        let webViewPresenter = WebViewPresenter()
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.modalPresentationStyle = .fullScreen
        hideLoading()
        self.navigationController?.pushViewController(webViewViewController, animated: true)
    }

    @objc
    private func paymentButtonTapped() {
        presenter?.pay()
    }
}

extension CurrencyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCollectionViewCell.identifier, for: indexPath) as? CurrencyCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.setupCell(with: currencies[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 46)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell as? CurrencyCollectionViewCell {
            cell.select()
        }
        selectedCurrency = currencies[indexPath.item]
        paymentButton.isEnabled = true
        paymentButton.backgroundColor = .segmentActive
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cell = cell as? CurrencyCollectionViewCell {
            cell.deselect()
        }
    }
}

extension CurrencyViewController: CurrencyViewProtocol {
    func showLoading() {
        ProgressHUD.animate()
    }

    func hideLoading() {
        ProgressHUD.dismiss()
    }

    func updateCurrencies(with currencies: [Currency]) {
        DispatchQueue.main.async {
            self.currencies = currencies
            self.collectionView.reloadData()
        }
    }
}
