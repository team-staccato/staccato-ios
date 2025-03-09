//
//  CategoryListFilterType.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

enum CategoryListFilterType {
    
    case term
    
    var serverKey: String {
        switch self {
        case .term: return "TERM"
        }
    }
    
}
