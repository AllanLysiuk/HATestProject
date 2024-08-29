import UIKit

final class SettingsTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        return label
    }()
    
    private var cellType: SettingsTableViewCellType = .aboutApp
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupStyle()
        addSubviews()
        setupConstraints()
    }
    
    private func setupStyle() {
        self.selectionStyle = .none
    }
    
    private func addSubviews() {
        self.contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    func configureCell(with type: SettingsTableViewCellType) {
        self.cellType = type
        self.titleLabel.text = type.cellName
    }
    
}
