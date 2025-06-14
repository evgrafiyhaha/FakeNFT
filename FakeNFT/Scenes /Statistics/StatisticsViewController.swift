import UIKit
import ProgressHUD

class StatisticsViewController: UIViewController {
    
    let presenter: StatisticsPresenter
    
    // MARK: - UI components
    
    lazy private var usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy private var filterButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(resource: .filterButton),
            target: nil,
            action: #selector(filterButtonTapped)
        )
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 42),
            button.heightAnchor.constraint(equalToConstant: 42)
        ])
        return button
    }()
    
    // MARK: - Init
    
    init(presenter: StatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(usersTableView)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            
            usersTableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 12),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        dataIsLoad()
    }
    
    // MARK: @objc functions
    
    @objc func filterButtonTapped() {
        
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.countOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        presenter.configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == presenter.countOfUsers else { return }
        presenter.loadNextPage()
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
}

// MARK: - StatisticsViewControllerDelegate

extension StatisticsViewController: StatisticsViewControllerDelegate {
    func updateUsersTable() {
        let oldCount = usersTableView.numberOfRows(inSection: 0)
        let newCount = presenter.countOfUsers
        usersTableView.performBatchUpdates() {
            if oldCount < newCount {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                usersTableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func updateRowUsersTable(at indexPath: IndexPath) {
        usersTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func dataIsLoad() {
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
    }

    func dataDidLoaded() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
}

