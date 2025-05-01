//
//  Ex+Date.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import Foundation

// Type Method
extension Date {
    static func fromString(_ dateString: String?, dateFormat: String = "yyyy-MM-dd") -> Date? {
        guard let dateString else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        return formatter.date(from: dateString)
    }

    init?(fromISOString dateString: String) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: dateString) {
            self = date
        } else {
            // Fallback for slightly different formats
            let alternativeFormatter = DateFormatter()
            alternativeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

            guard let date = alternativeFormatter.date(from: dateString) else {
                return nil
            }

            self = date
        }
    }
}

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

    var formattedAsISO8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
