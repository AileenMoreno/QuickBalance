//
//  Constants.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 22-01-22.
//

import Foundation

struct Constants {
    static let applicationName = "QuickBalance"
    static let defaultDescription = "unknown transaction"
    static let expenses = "Expenses"
    static let incomes = "Incomes"
    static let balance = "Balance"

    struct Alert {
        static let okey = "OK."
        static let title = "HEY!"
        static let message = "Your data was succesfully saved!."
    }
    
    struct ActionSheet {
        static let cancel = "Cancel"
        static let delete = "Delete"
        static let title = "Delete the transaction?"
        static let message = "You would not recover this item."
    }
    
    struct Error {
        static let emptyData = "There are no transactions available! Add new ones to see your balance."
        static let alertTitle = "OH NO!"
        static let alertMessage = "There was a problem saving your data."
    }
    
    struct Image {
        static let coin = "coin"
    }
}

