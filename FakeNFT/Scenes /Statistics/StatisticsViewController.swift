import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController {
    
    let presenter: StatisticsPresenter
    
    // MARK: - UI components
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(resource: .filterButton),
            target: self,
            action: #selector(showSortAlert)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        
        NSLayoutConstraint.activate([
            usersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        presenter.loadData()
    }
    
    // MARK: @objc functions
    
    @objc private func refreshData() {
        self.refreshControl.endRefreshing()
        presenter.refreshData()
    }
    
    @objc func showSortAlert() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let sortByNameAction = UIAlertAction(title: "По имени", style: .default) { [weak self] _ in
            print("Сортировка по имени")
            let sortParameter = SortType.name
            self?.presenter.filterUsers(by: sortParameter)
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            print("Сортировка по рейтингу")
            let sortParameter = SortType.rating
            self?.presenter.filterUsers(by: sortParameter)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.countOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as? UsersTableViewCell
        guard let cell else {
            fatalError("Could not dequeue cell with identifier: UsersTableViewCell")
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userCardPresenter = UserCardPresenter(service: presenter.service, index: indexPath.row)
        let controller = UserCardViewController(presenter: userCardPresenter)
        userCardPresenter.delegate = controller
        navigationController?.pushViewController(controller, animated: true)
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
    
    func updateFullUsersTable() {
        usersTableView.reloadData()
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

