//
//  DetailBannerView.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 26-01-22.
//

import UIKit

class DetailBannerView: UIView {

    private var data: (title:String, subtitle: String?)! {
        didSet {
            self.refreshData()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 95).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 95).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    
    func loadData(from title: String, subtitle: String?) {
        self.data = (title, subtitle)
    }
    
    private func configureView() {
        configureStackView()
        configureConstraints()
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        addSubview(stackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    private func refreshData() {
        self.titleLabel.text = data?.title
        self.subtitleLabel.text = data?.subtitle
    }
}
