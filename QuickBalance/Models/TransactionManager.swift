//
//  TransactionManager.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 23-01-22.
//

import Foundation
import RealmSwift


class TransactionManager {
    
    class func add(type: String, description: String, amount: Double) -> Bool {
        
        let transaction = Transaction()
        transaction.type = type
        transaction.name = description
        transaction.amount = amount
        transaction.date = Calendar.current.startOfDay(for: Date())
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(transaction)
            }
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    class func delete(transaction: Transaction) {
        do {
            let predicate = NSPredicate(format: "_id == %@", transaction._id)
            let realm = try Realm()

            if let item = realm.objects(Transaction.self).filter(predicate).first {
                realm.beginWrite()
                realm.delete(item)
                try realm.commitWrite()
            }
        } catch _ as NSError {
            print("explode")
        }
    }
    
    class func loadAllGroupedByDate() -> [[Transaction]] {
        let query = try! Realm().objects(Transaction.self).sorted(byKeyPath: "date",
                                                                  ascending: false)
        
        return query
            .map{ $0.date } // List of dates
            .reduce([]) { dates, date in
                return dates.last == date ? dates : dates + [date]
            } // List of dates with no repetition
            .map({ section -> ([Transaction]) in
                let result = query.filter{ $0.date == section }
                return Array(result)
            }) //grouped list of transactions
    }
    
    class func calculateBalance(from transactions: [[Transaction]]) -> Balance {
        let (expenses, incomes) = transactions
            .flatMap{ $0 } // flatten list
            .reduce((0.0,0.0)) { result, item in
                if item.type == TransactionType.expense.rawValue {
                    return (result.0 + item.amount, result.1) // acumulate expense
                } else {
                    return (result.0, result.1 + item.amount) // acumulate income
                }
            }
        
        let total = incomes - expenses
        return Balance(expenses: expenses, incomes: incomes, total: total)
    }
}
