//
//  Ex+Date.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import Foundation

extension Date {
    var formattedAsFullDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: self)
    }
}
