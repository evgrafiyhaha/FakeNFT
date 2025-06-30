import UIKit

final class ConfirmDeleteViewController: UIViewController {

    var onDelete: (() -> Void)?

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .placeholder)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.redUniversal, for: .normal)
        button.backgroundColor = .segmentActive
        button.titleLabel?.font = .bodyRegular
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        return button
    }()

    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .bodyRegular
        button.backgroundColor = .segmentActive
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.font = .caption2
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBlur()
        setupContent()
    }

    func setupImage(_ image: UIImage) {
        nftImageView.image = image
    }

    private func setupBlur() {
        view.backgroundColor = .clear
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    private func setupContent() {
        let stack = UIStackView(arrangedSubviews: [deleteButton, returnButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually

        let contentStack = UIStackView(arrangedSubviews: [nftImageView, titleLabel])
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.alignment = .center

        let mainStack = UIStackView(arrangedSubviews: [contentStack, stack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),

            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            returnButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            returnButton.widthAnchor.constraint(equalTo: deleteButton.widthAnchor),
        ])
    }

    @objc private func didTapDelete() {
        dismiss(animated: true) {
            self.onDelete?()
        }
    }

    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
}

