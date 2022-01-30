//
//  BalanceViewController.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 22-01-22.
//

import UIKit

typealias DailyTransaction = [Transaction]

class BalanceViewController: UIViewController {
    
    // MARK: Properties
    
    private var tableView: UITableView!
    private var emptyBalanceView: EmptyBalanceView!
    private var headerView: UIView?
    private var transactions: [DailyTransaction] = []
    
    private var balance: Balance? {
        didSet {
            self.refreshView()
        }
    }
    
    private var activityIndicatorView: UIActivityIndicatorView?
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadBalanceData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        DispatchQueue.main.async {
            self.tableView.tableHeaderView?.layoutIfNeeded()
            self.tableView.tableHeaderView = self.tableView.tableHeaderView
          }
    }
    
    // MARK: Private Functions
    
    private func configureView() {
        title = Constants.applicationName
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(handleAddButtonBarTapped))
        navigationItem.rightBarButtonItems = [addBarButtonItem]
    }
    
    private func loadBalanceData() {
        transactions = TransactionManager.loadAllGroupedByDate()
        balance = TransactionManager.calculateBalance(from: transactions)
    }
    
    private func refreshView() {
        if transactions.count == 0 {
            loadEmptyView()
        } else {
            loadTableView()
        }
    }
    
    private func loadEmptyView() {
        if tableView != nil {
            tableView.removeFromSuperview()
        }
        
        emptyBalanceView = EmptyBalanceView()
        view.addSubview(emptyBalanceView)
        emptyBalanceView.configureView(with: view)
    }
    
    
    private func loadTableView() {
        if emptyBalanceView != nil {
            emptyBalanceView.removeFromSuperview()
        }
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        configureTableViewConstraints()
        registerTableViewCells()
        configureTableHeaderView()
    }
    
    private func configureTableHeaderView() {
        guard let balance = balance else {
            return
        }

        let headerView = BannerHeaderView()
        headerView.loadData(from: balance)
        self.tableView.tableHeaderView = headerView
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.headerView = headerView
        
        configureHeaderViewConstrains()
        
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    private func configureHeaderViewConstrains() {
        guard let headerView = headerView else {
            return
        }

        NSLayoutConstraint.activate([
            headerView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            headerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)])
    }
    
    private func configureTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    private func registerTableViewCells() {
        
        tableView.register(SectionHeaderTableView.self,
                           forHeaderFooterViewReuseIdentifier: SectionHeaderTableView.reuseIdentifier)
        
        tableView.register(BalanceTableViewCell.self,
                           forCellReuseIdentifier: BalanceTableViewCell.reuseIdentifier)
    }
    
    private func transaction(from indexPath: IndexPath) -> Transaction {
        let dailyBalance = transactions[indexPath.section]
        return dailyBalance[indexPath.row]
    }
    
    private func showActivityIndicator() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        activityIndicatorView = activityView
    }
    
    private func hideActivityIndicator() {
        if activityIndicatorView != nil {
            activityIndicatorView?.stopAnimating()
            navigationItem.rightBarButtonItem?.isEnabled = true
            view.isUserInteractionEnabled = true
        }
    }
    
    private func showDeleteTransactionActionSheet(_ transaction: Transaction) {
        let destroyAction = UIAlertAction(title: Constants.ActionSheet.delete,
                                          style: .destructive) { (action) in
            self.performDeleteTransaction(transaction: transaction)
        }
        
        let cancelAction = UIAlertAction(title: Constants.ActionSheet.cancel,
                                         style: .cancel) { (action) in
            // Respond to user selection of the action
        }
        
        let alert = UIAlertController(title: Constants.ActionSheet.title,
                                      message: Constants.ActionSheet.message,
                                      preferredStyle: .actionSheet)
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func performDeleteTransaction(transaction: Transaction) {
        showActivityIndicator()
        transactions = []
        TransactionManager.delete(transaction: transaction)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.loadBalanceData()
            self.hideActivityIndicator()
        }
    }
    
    // MARK: Handlers
    
    @objc private func handleAddButtonBarTapped() {
        let controller = AddTransactionViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension BalanceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let transaction = transactions[section].first,
              let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SectionHeaderTableView.reuseIdentifier)
                as? SectionHeaderTableView else {
            return nil
        }
        view.loadData(from: transaction)
        return view
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BalanceTableViewCell.estimatedHeight
    }
}

// MARK: - UITableViewDataSource
extension BalanceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return transactions[section].count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dailyBalance = transactions[indexPath.section]
        let transaction = dailyBalance[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BalanceTableViewCell.reuseIdentifier) as! BalanceTableViewCell
        
        cell.fill(from: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = transaction(from: indexPath)
            showDeleteTransactionActionSheet(transaction)
        }
    }
}

// MARK: - AddTransactionDelegate
extension BalanceViewController: AddTransactionDelegate {
    func didAddTransaction() {
        loadBalanceData()
    }
}

