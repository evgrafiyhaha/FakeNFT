import UIKit

final class SuccessViewController: UIViewController {

    private lazy var successImageView = {
        let imageView = UIImageView(image: UIImage(resource: .success))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel = {
        let label = UILabel()
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        label.font = .headline3
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться в корзину", for: .normal)
        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.segmentActiveWhite, for: .normal)
        button.backgroundColor = .segmentActive
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(Self.didTapReturnButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupSubviews() {
        view.backgroundColor = .systemBackground
        view.addSubview(returnButton)
        view.addSubview(titleLabel)
        view.addSubview(successImageView)
    }

    private func setupConstraints() {
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        successImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor,constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: returnButton.topAnchor, constant: -152),

            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            returnButton.heightAnchor.constraint(equalToConstant: 60),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    @objc
    private func didTapReturnButton() {
        navigationController?.popToRootViewController(animated: true)
    }

}
