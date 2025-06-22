import UIKit
import WebKit

final class UserCardWebViewController: UIViewController {
    
    var presenter: UserCardWebViewPresenter?
    
    // MARK: - UI components

    lazy var userWebView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.tintColor = .black
        progress.trackTintColor = .clear
        progress.alpha = 0
        return progress
    }()

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
    
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        view.addSubview(userWebView)
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),

            userWebView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            userWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        observeWebViewProgress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadUserPage()
    }
    
    // MARK: - Private functions

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.presenter?.loadUserPage()
        })
        present(alert, animated: true)
    }
    
    private func observeWebViewProgress() {
        progressObservation = userWebView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
            guard let self = self else { return }
            let progress = Float(webView.estimatedProgress)

            self.progressView.alpha = 1
            self.progressView.setProgress(progress, animated: true)

            if progress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.progressView.alpha = 0
                    }) { _ in
                        self.progressView.setProgress(0, animated: false)
                    }
                }
            }
        }
    }
    
    // MARK: - @Objc functions

    @objc private func backButtonTapped() {
        userWebView.stopLoading()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension UserCardWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let nsError = error as NSError
        if nsError.code == NSURLErrorCancelled {
            return
        }

        showErrorAlert(message: "Не удалось загрузить страницу")
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        showErrorAlert(message: "Произошла ошибка при загрузке страницы. Повторите попытку.")
    }
}
