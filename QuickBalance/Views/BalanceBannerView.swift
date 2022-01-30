//
//  BannerHeaderTableView.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 22-01-22.
//

import UIKit

class BannerHeaderTableView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    static let reuseIdentifier: String = String(describing: self)
    
    private var balance: Balance? {
        didSet {
            self.refreshData()
        }
    }
    
    private let expensesView: DetailBannerView = {
        let view = DetailBannerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let incomesView: DetailBannerView = {
        let view = DetailBannerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let balanceView: DetailBannerView = {
        let view = DetailBannerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 12
        stackView.layer.masksToBounds = false
        return stackView
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
    
    func loadData(from balance: Balance) {
        self.balance = balance
    }
    
    // MARK: Private Functions
    
    private func configureView() {
        dataStackView.backgroundColor = .purple
        configureStackView()
        configureConstraints()
    }
    
    private func configureStackView() {
        dataStackView.addArrangedSubview(expensesView)
        dataStackView.addArrangedSubview(incomesView)
        dataStackView.addArrangedSubview(balanceView)
        contentView.addSubview(dataStackView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            dataStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dataStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dataStackView.topAnchor.constraint(equalTo: topAnchor),
            dataStackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
    private func refreshData() {

        expensesView.loadData(from: Constants.expenses,
                              subtitle: balance?.expenses.toMoney())
        incomesView.loadData(from: Constants.incomes,
                             subtitle: balance?.incomes.toMoney())
        balanceView.loadData(from: Constants.balance,
                             subtitle: balance?.total.toMoney())
    }
}
