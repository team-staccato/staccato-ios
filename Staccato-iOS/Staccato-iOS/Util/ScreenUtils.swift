//
//  ScreenUtils.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/4/25.
//

import SwiftUI

struct ScreenUtils {
    
    // MARK: 디바이스 width
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    
    // MARK: 디바이스 height
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    
    // MARK: 디바이스 SafeAreaInsets (최상위 창 기준)
    
    static var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets ?? .zero
    }
    
}
