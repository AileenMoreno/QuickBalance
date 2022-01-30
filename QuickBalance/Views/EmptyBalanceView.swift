//
//  EmptyBalanceView.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 25-01-22.
//

import UIKit

class EmptyBalanceView: UIView {

    // MARK: Properties
    
    private var message: String!
    private var imageName: String!
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .justified
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 340).isActive = true
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        view.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        return view
    }()
    
    // MARK: Initializers
    
    init(message: String? = nil, imageName: String? = nil) {
        super.init(frame: CGRect.zero)
        self.message = message ?? Constants.Error.emptyData
        self.imageName = imageName ?? Constants.Image.coin
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    
    func configureView(with parent: UIView) {
        backgroundColor = .white
        configureStackView()
        configureConstraints(with: parent)
        loadData()
    }
    
    // MARK: Private Functions
    
    private func configureStackView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabel)
        containerView.addSubview(stackView)
        addSubview(containerView)
    }
    
    private func configureConstraints(with parent: UIView) {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
           
           stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
           stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func loadData() {
        self.descriptionLabel.text = message
        self.imageView.image = UIImage(named: imageName)
    }
}

