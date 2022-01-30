//
//  Balance.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 22-01-22.
//

import Foundation
import RealmSwift

class Transaction: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted var amount: Double
    @Persisted var type: String
}
