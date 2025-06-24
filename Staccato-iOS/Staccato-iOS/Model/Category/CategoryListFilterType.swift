//
//  CategoryListFilterType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum CategoryListFilterType: CaseIterable, Identifiable {
    
    case all, term, withoutTerm
    
    var id: Int {
        switch self {
        case .all: return 0
        case .term: return 1
        case .withoutTerm: return 2
        }
    }
    
    var serverKey: String? {
        switch self {
        case .all: return nil
        case .term: return "WITH_TERM"
        case .withoutTerm: return "WITHOUT_TERM"
        }
    }
    
    var text: String {
        switch self {
        case .all: return "모든 카테고리"
        case .term: return "기간 있는 카테고리만"
        case .withoutTerm: return "기간 없는 카테고리만"
        }
    }
    
}
