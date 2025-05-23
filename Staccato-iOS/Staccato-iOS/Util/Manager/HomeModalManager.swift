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
    var modalSize: ModalSize = .medium // 최신 사이즈
    var previousModalSize: ModalSize = .medium // 모달 크기가 조정될 때 지도를 scroll할 deltaY를 계산하기 위해 기억하는 사이즈

    func updateHeight(to height: CGFloat) {
        modalHeight = height
    }
    
    func updateSize(to size: ModalSize) {
        modalSize = size
        modalHeight = modalSize.height
    }
    
    func setFinalSize(translationAmount: CGFloat) {
        // 위로 5 이상 드래그한 경우
        if translationAmount < -5 {
            modalSize = modalSize.upperSize
        }
        
        // 아래로 5 이상 드래그한 경우
        else if translationAmount > 5 {
            modalSize = modalSize.lowerSize
            dismissKeyboard() // small, medium 사이즈에서 키보드 비활성화
        }

        modalHeight = modalSize.height
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
