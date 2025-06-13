//
//  CategoryListFilterType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum CategoryListFilterType: CaseIterable, Identifiable {
    
    case all, term
    
    var id: Int {
        switch self {
        case .all: return 0
        case .term: return 1
        }
    }
    
    var serverKey: String? {
        switch self {
        case .all: return nil
        case .term: return "WITH_TERM"
        }
    }
    
    var text: String {
        switch self {
        case .all: return "전체 보기"
        case .term: return "기간 설정된 카테고리만 보기"
        }
    }
    
}
