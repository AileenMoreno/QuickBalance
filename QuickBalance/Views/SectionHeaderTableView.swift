//
//  SectionHeaderTableView.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 25-01-22.
//

import UIKit

class SectionHeaderTableView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    
    static let reuseIdentifier: String = String(describing: self)
    
    private var transaction: Transaction? {
        didSet {
            self.refreshData()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = false
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

    
    // MARK: Initializers
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions
    
    func loadData(from transaction: Transaction) {
        self.transaction = transaction
    }
    
    // MARK: Private Functions
    
    private func configureView() {
        configureStackView()
        configureConstraints()
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(logoImageView)
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func refreshData() {
        guard let transaction = transaction else {
            return
        }
        
        self.titleLabel.text = transaction.date.toSectionFormat()
        self.logoImageView.image = UIImage(named: Constants.Image.coin)
    }
}
