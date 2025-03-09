//
//  CategoryListSortType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum CategoryListSortType {
    
    case recentlyUpdated, newest, oldest
    
    var serverKey: String {
        switch self {
        case .recentlyUpdated: return "RECENTLY_UPDATED"
        case .newest: return "NEWEST"
        case .oldest: return "OLDEST"
        }
    }
    
}
