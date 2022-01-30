//
//  DateExtension.swift
//  QuickBalance
//
//  Created by Aileen Gabriela Moreno Perez on 25-01-22.
//


import Foundation

extension Date {
    func toSectionFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self).capitalized
    }
}

