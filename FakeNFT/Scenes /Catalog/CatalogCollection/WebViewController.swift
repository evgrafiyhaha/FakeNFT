//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Olya on 19.06.2025.
//

import Foundation
import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private let url: URL
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
            let progress = UIProgressView(progressViewStyle: .default)
        progress.tintColor = .black
            progress.trackTintColor = .clear
            progress.alpha = 0
            return progress
        }()
    
    private var webView: WKWebView = WKWebView()
    
    
    private var progressObservation: NSKeyValueObservation?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progressObservation?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView.navigationDelegate = self
        navigationController?.isNavigationBarHidden = false
        setupUI()
        setupProgressObserver()
        webView.load(URLRequest(url: url))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        
        [webView, progressView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
          
        ])
        
        
    }
    
    private func setupProgressObserver() {
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, change in
            guard let self = self else { return }
            let progress = Float(change.newValue ?? 0)
            self.progressView.setProgress(progress, animated: true)

            if progress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut) {
                    self.progressView.alpha = 0
                } completion: { _ in
                    self.progressView.setProgress(0, animated: false)
                }
            } else {
                self.progressView.alpha = 1
            }
        }
    }

    
    @objc private func backButtonDidTap(){
        if let navigationController = navigationController, navigationController.viewControllers.first != self {
                navigationController.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
    }
    
    
}

extension WebViewController: WKNavigationDelegate {
    
}



