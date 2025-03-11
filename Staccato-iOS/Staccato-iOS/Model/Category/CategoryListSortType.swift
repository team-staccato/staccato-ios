//
//  CategoryListSortType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum CategoryListSortType: CaseIterable, Identifiable {
    
    case recentlyUpdated, newest, oldest
    
    var id: Int {
        switch self {
        case .recentlyUpdated: return 0
        case .newest: return 1
        case .oldest: return 2
        }
    }
    
    var serverKey: String {
        switch self {
        case .recentlyUpdated: return "RECENTLY_UPDATED"
        case .newest: return "NEWEST"
        case .oldest: return "OLDEST"
        }
    }
    
    var text: String {
        switch self {
        case .recentlyUpdated: return "최근 수정 순"
        case .newest: return "최신 순"
        case .oldest: return "오래된 순"
        }
    }
    
}
