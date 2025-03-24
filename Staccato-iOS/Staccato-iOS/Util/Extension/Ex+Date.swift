//
//  Ex+Date.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import Foundation

extension Date {
    var formattedAsRequestDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    var formattedAsFullDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: self)
    }
    
    var formattedAsMonthAndDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }

    var formattedAsYearAndMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }

    var formattedAsFullDateWithHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY년 MM월 dd일 a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
