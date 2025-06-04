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
}

@MainActor
final class BottomSheetDetentManager: ObservableObject {

    @Published var currentHeight: CGFloat = BottomSheetDetent.medium.height // 실시간으로 반영되는 사이즈
    @Published var currentDetent: BottomSheetDetent = .medium // 최신 사이즈
    @Published var previousDetent: BottomSheetDetent? = nil
    @Published var isbottomSheetPresented: Bool = true
    @Published var selectedDetent: PresentationDetent = BottomSheetDetent.medium.detent
    
    func updateDetent(_ newHeight: CGFloat) {
        previousDetent = currentDetent
        currentHeight = newHeight
        
        let detectedDetent = detectDetent(from: newHeight)
        
        if detectedDetent != currentDetent {
            currentDetent = detectedDetent
        }
    }
    
    func updateDetent(to size: BottomSheetDetent) {
        previousDetent = currentDetent
        currentDetent = size
        currentHeight = currentDetent.height
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
