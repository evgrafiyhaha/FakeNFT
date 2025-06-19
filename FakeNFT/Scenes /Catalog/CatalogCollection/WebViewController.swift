//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Olya on 19.06.2025.
//

import Foundation
import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController {
    
    private let url: URL
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var webView: WKWebView = WKWebView()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        webView.load(URLRequest(url: url))
        
    }
    
    private func setupUI() {
        
        [webView, backButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 42),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        
    }
    
    @objc private func backButtonDidTap(){
        dismiss(animated: true)
    }
    
    
}

