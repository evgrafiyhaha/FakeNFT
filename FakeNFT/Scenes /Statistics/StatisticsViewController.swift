import UIKit

class StatisticsViewController: UIViewController {
    
    let presenter: StatisticsPresenter
    
    lazy var UsersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var filterButton: UIButton = {
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
    
    init(presenter: StatisticsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(UsersTableView)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            
            UsersTableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 12),
            UsersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            UsersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            UsersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func filterButtonTapped() {
        
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as! UsersTableViewCell
        let user = presenter.users[indexPath.row]
        cell.numberLabel.text = String(indexPath.row)
        cell.avatarImageView.image = user.image
        cell.nameLabel.text = user.name
        cell.ratingLabel.text = String(user.rating)
        
        cell.separatorInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
}
