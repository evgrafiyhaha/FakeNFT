//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Olya on 10.06.2025.
//

import UIKit
import ProgressHUD
import Kingfisher

protocol CatalogViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func updateCollections(_ collections: [CatalogCollection])
    func showError(_ message: String)
}

class CatalogViewController: UIViewController {
    
    private var collection: [CatalogCollection] = []
    private var presenter: CatalogPresenterProtocol!
    private let servicesAssembly: ServicesAssembly
    private let sortOptionKey = "catalogSortOption"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filterButton"), for: .normal)
        button.addTarget(self, action: #selector(filterButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    init(serviceAssembly: ServicesAssembly) {
        self.servicesAssembly = serviceAssembly
        super.init(nibName: nil, bundle: nil)
        self.presenter = CatalogPresenter(view: self, networkService: serviceAssembly.catalogNetworkClient)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        filterButton.isEnabled = false
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        [tableView, filterButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 44),
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func filterButtonDidTap(){
        
        let alert = UIAlertController(title: "", message: "Сортировка", preferredStyle: .actionSheet)
        let sortByName = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.applySort(.name)
        }
        
        let sortByCount = UIAlertAction(title: "По количеству NFT", style: .default) { [weak self] _ in
            self?.applySort(.count)
        }
        
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(sortByName)
        alert.addAction(sortByCount)
        alert.addAction(closeAction)
        
        present(alert, animated: true)
    }
    
    private func applySort(_ option: CatalogSortOption) {
            UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)

            switch option {
            case .name:
                self.collection.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
            case .count:
                self.collection.sort { $0.nfts.count > $1.nfts.count }
            }

            self.tableView.reloadData()
        }
    
}

extension CatalogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier, for: indexPath) as? CatalogCell,
              let urlString = collection[indexPath.row].cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return UITableViewCell()
        }
        cell.configure(imageURL: URL(string: urlString), text: "\(collection[indexPath.row].name) (\(collection[indexPath.row].nfts.count))"
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CatalogCollectionVC(catalogCollection: collection[indexPath.row], servicesAssembly: servicesAssembly)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

extension CatalogViewController: CatalogViewProtocol {
    func showLoading() {
        ProgressHUD.show()
        filterButton.isEnabled = false
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
        filterButton.isEnabled = true
    }
    
    func updateCollections(_ collections: [CatalogCollection]) {
        self.collection = collections
        
        if let savedValue = UserDefaults.standard.string(forKey: sortOptionKey),
           let savedSortOption = CatalogSortOption(rawValue: savedValue) {
            applySort(savedSortOption)
        } else {
            tableView.reloadData()
        }
        filterButton.isEnabled = true
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка при загрузке данных", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
}
