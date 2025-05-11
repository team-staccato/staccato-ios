//
//  HomeModalManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/7/25.
//

import SwiftUI
import Observation

@Observable
final class HomeModalManager {

    var modalHeight: CGFloat = ModalSize.medium.height // 실시간으로 반영되는 사이즈
    private var modalSize: ModalSize = .medium // 이전으로 되돌리기 위해 기억하는 사이즈
    
    func updateHeight(to height: CGFloat) {
        modalHeight = height
    }
    
    func updateSize(to size: ModalSize) {
        modalSize = size
        modalHeight = modalSize.height
    }
    
    func setFinalSize(translationAmount: CGFloat) {
        if translationAmount < -10 { // 위로 10 이상 드래그한 경우
            modalSize = modalSize.upperSize
        } else if translationAmount > 10 { // 아래로 10 이상 드래그한 경우
            modalSize = modalSize.lowerSize
        }

        modalHeight = modalSize.height
    }

    enum ModalSize: CaseIterable {
        case small, medium, large
        
        var height: CGFloat {
            switch self {
            case .small: return 73 / 640 * ScreenUtils.height
            case .medium: return ScreenUtils.height * 0.6
            case .large: return ScreenUtils.height - ScreenUtils.safeAreaInsets.top
            }
        }
        
        var upperSize: ModalSize {
            switch self {
            case .small: return .medium
            case .medium: return .large
            case .large: return .large
            }
        }
        
        var lowerSize: ModalSize {
            switch self {
            case .small: return .small
            case .medium: return .small
            case .large: return .medium
            }
        }
    }

}
