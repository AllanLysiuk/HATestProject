import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SettingsTableViewCell.self,
            forCellReuseIdentifier: "\(SettingsTableViewCell.self)"
        )
        return tableView
    }()
    
    // MARK: - Private variables
    
    private var viewModel: SettingsVMProtocol
    
    // MARK: - Life cycle
    
    init(viewModel: SettingsVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        requiredInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func requiredInit() {
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gear"), tag: 1)
        navigationController?.tabBarItem = tabBarItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        setupStyle()
        addSubviews()
        setupConstraints()
        setupNavigationItems()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .white
    }
    
    private func addSubviews() {
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - Private methods
    
    private func setupNavigationItems() {
        self.navigationItem.title = "Настройки"
    }
    
}

// MARK: - UITableViewDelegate extension

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = viewModel.settingsCell[indexPath.row]
        switch cellType {
            case .aboutApp:
            viewModel.openAboutAppPopUp()
        }
    }
}

// MARK: - UITableViewDataSource extension

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(SettingsTableViewCell.self)",
            for: indexPath
        ) as! SettingsTableViewCell
        
        cell.configureCell(with: viewModel.settingsCell[indexPath.row])
        return cell
    }
    
}
