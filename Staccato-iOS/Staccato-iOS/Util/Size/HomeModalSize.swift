//
//  HomeModalSize.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import Foundation

enum HomeModalSize: CaseIterable {
    
    case small, medium, large
    
    var height: CGFloat {
        switch self {
        case .small: return 74 / 640 * ScreenUtils.height
        case .medium: return ScreenUtils.height / 2
        case .large: return ScreenUtils.height - ScreenUtils.safeAreaInsets.top - 10
        }
    }
    
}
