//
//  BannerHeaderView.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 22-01-22.
//

import UIKit

class BannerHeaderView: UIView {
    
    // MARK: Properties
    
    private var balance: Balance? {
        didSet {
            self.refreshData()
            self.refreshProgressView()
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
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .darkGray
        progressView.transform = CGAffineTransform(scaleX: 1, y: 3.5)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let leadingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    private let trailingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    private let progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    
    func loadData(from balance: Balance) {
        self.balance = balance
        configureView()
    }
    
    // MARK: Private Functions
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        configureStackView()
        configureConstraints()
    }
    
    private func configureStackView() {
        dataStackView.addArrangedSubview(expensesView)
        dataStackView.addArrangedSubview(incomesView)
        dataStackView.addArrangedSubview(balanceView)
        
        progressStackView.addArrangedSubview(leadingView)
        progressStackView.addArrangedSubview(progressView)
        progressStackView.addArrangedSubview(trailingView)
        
        stackView.addArrangedSubview(dataStackView)
        stackView.addArrangedSubview(progressStackView)
        
        containerView.addSubview(stackView)
        addSubview(containerView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    private func refreshData() {

        expensesView.loadData(from: Constants.expenses,
                              subtitle: balance?.expenses.toMoney())
        incomesView.loadData(from: Constants.incomes,
                             subtitle: balance?.incomes.toMoney())
        balanceView.loadData(from: Constants.balance,
                             subtitle: balance?.total.toMoney())
    }
    
    private func refreshProgressView() {
        let expenses = balance?.expenses ?? 0
        let total = balance?.total ?? 1
        progressView.setProgress(0, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let value = Float(expenses / total)
            self.progressView.setProgress(value, animated: true)
        }
    }
}
