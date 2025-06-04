//
//  BottomSheetDetentManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/7/25.
//

import SwiftUI
import Observation

enum BottomSheetDetent: CaseIterable {
    case small, medium, large
    
    var height: CGFloat {
        switch self {
        case .small: return 90
        case .medium: return ScreenUtils.height * 0.6
        case .large: return ScreenUtils.height - ScreenUtils.safeAreaInsets.top
        }
    }
    
    var detent: PresentationDetent {
        return .height(self.height)
    }
    
    var upperSize: BottomSheetDetent {
        switch self {
        case .small: return .medium
        case .medium: return .large
        case .large: return .large
        }
    }
    
    var lowerSize: BottomSheetDetent {
        switch self {
        case .small: return .small
        case .medium: return .small
        case .large: return .medium
        }
    }
}

@MainActor
final class BottomSheetDetentManager: ObservableObject {

    @Published var currentHeight: CGFloat = BottomSheetDetent.medium.height // 실시간으로 반영되는 사이즈
    @Published var currentDetent: BottomSheetDetent = .medium // 최신 사이즈
    @Published var targetDetent: BottomSheetDetent? = nil
    @Published var isbottomSheetPresented: Bool = true
    
    func updateHeight(_ newHeight: CGFloat) {
        currentHeight = newHeight
        
        let detectedDetent = detectDetent(from: newHeight)
        
        if detectedDetent != currentDetent {
            currentDetent = detectedDetent
        }
        
        // 목표 detent 달성 시 초기화
        if let target = targetDetent, target == currentDetent {
            targetDetent = nil
        }
    }
    
    func updateSize(to size: BottomSheetDetent) {
        currentDetent = size
        currentHeight = currentDetent.height
    }
    
    func setFinalSize(translationAmount: CGFloat) {
        // 위로 5 이상 드래그한 경우
        if translationAmount < -5 {
            currentDetent = currentDetent.upperSize
        }
        
        // 아래로 5 이상 드래그한 경우
        else if translationAmount > 5 {
            currentDetent = currentDetent.lowerSize
            dismissKeyboard() // small, medium 사이즈에서 키보드 비활성화
        }

        currentHeight = currentDetent.height
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func detectDetent(from height: CGFloat) -> BottomSheetDetent {
        if height < BottomSheetDetent.small.height {
            return .small
        } else if height < BottomSheetDetent.medium.height {
            return .medium
        } else {
            return .large
        }
    }
}
