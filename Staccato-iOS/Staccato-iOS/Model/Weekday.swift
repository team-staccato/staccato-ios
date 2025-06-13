//
//  Weekday.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/22/25.
//

import Foundation

enum Weekday: Int, CaseIterable {
    case sunday = 0, monday, tuesday, wednesday, thursday, friday, saturday

    var localizedName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.shortWeekdaySymbols[self.rawValue]
    }
}
