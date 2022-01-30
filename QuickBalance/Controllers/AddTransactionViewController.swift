//
//  AddTransactionViewController.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 23-01-22.
//

import UIKit

protocol AddTransactionDelegate: AnyObject {
    func didAddTransaction()
}

class AddTransactionViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    weak var delegate: AddTransactionDelegate?
    
    private var didAddTransaction = false
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: Methods
    
    private func configureView() {
        view.backgroundColor = .clear
        view.isOpaque = false
        definesPresentationContext = true
        configurePopUpView()
    }
    
    private func configurePopUpView() {
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        view.bringSubviewToFront(popUpView)
    }
    
    private func showUpdateTransactionMessage(result: Bool) {
        var alertTitle = Constants.Error.alertTitle
        var alertMessage = Constants.Error.alertMessage
        
        if result {
            alertTitle = Constants.Alert.title
            alertMessage = Constants.Alert.message
        }
        
        let action = UIAlertAction(title: Constants.Alert.okey,
                                   style: .default) { (action) in
            self.typeSegmentControl.selectedSegmentIndex = 0
            self.descriptionTextField.text = ""
            self.amountTextField.text = ""
        }
        
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    // MARK: Handlers
    
    @IBAction func handleCloseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            if self.didAddTransaction {
                self.delegate?.didAddTransaction()
            }
        })
    }
    
    @IBAction func handleAddButtonTapped(_ sender: UIButton) {
        let index = typeSegmentControl.selectedSegmentIndex
        let type = index == 0 ? TransactionType.expense : TransactionType.income
        let description = descriptionTextField.text ?? Constants.defaultDescription
        let amountString = amountTextField.text ?? "0.0"
        let amount = Double(amountString) ?? 0.0
        
        let result = TransactionManager.add(type: type.rawValue,
                                            description: description,
                                            amount: amount)
        didAddTransaction = result
        showUpdateTransactionMessage(result: result)
    }
}
