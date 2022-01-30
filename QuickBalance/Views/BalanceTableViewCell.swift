//
//  BalanceTableViewCell.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 22-01-22.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let reuseIdentifier: String = String(describing: self)
    static let estimatedHeight: CGFloat = 50.0
    
    private var model: Transaction? {
        didSet {
            self.refreshData()
        }
    }
    
    private let leadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.widthAnchor.constraint(equalToConstant: 8.0).isActive = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private let trailingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.widthAnchor.constraint(equalToConstant: 8.0).isActive = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = false
        stackView.layer.borderColor = UIColor.systemGray6.cgColor
        stackView.layer.borderWidth = 4
        return stackView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
    }
    
    // MARK: Functions
    
    func fill(from model: Transaction) {
        self.model = model
    }
    
    // MARK: Private Functions
    
    private func configureCell() {
        configureStackView()
        configureConstraints()
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(leadingView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(trailingView)
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    private func refreshData() {
        guard let model = model else {
            return
        }
        
        self.titleLabel.text = model.name.capitalized
        self.descriptionLabel.text = getAmountFormatted(model.amount, type: model.type)
    }
    
    private func getAmountFormatted(_ amount: Double, type: String) -> String {
        
        var amountFormatted = amount.toMoney()
        
        if type == TransactionType.expense.rawValue {
            amountFormatted = amountFormatted.toNegative()
        }
        return amountFormatted
    }
}
