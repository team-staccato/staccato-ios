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
        case .small: return 80
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
    
    var previousDetent: BottomSheetDetent = .medium
    @Published var currentDetent: BottomSheetDetent = .medium
    @Published var selectedDetent: PresentationDetent = BottomSheetDetent.medium.detent
    @Published var isbottomSheetPresented: Bool = false
    
    func updateDetent(_ newHeight: CGFloat) {
        if let detectedDetent = detectDetent(from: newHeight) {
            currentDetent = detectedDetent
        }
    }
    
    func updateDetent(to size: BottomSheetDetent) {
        if currentDetent != size {
            currentDetent = size
        }
    }
    
    private func detectDetent(from height: CGFloat) -> BottomSheetDetent? {
        if height > BottomSheetDetent.small.height - 5 && height < BottomSheetDetent.small.height + 5 {
            return .small
        } else if height > BottomSheetDetent.medium.height - 5 && height < BottomSheetDetent.medium.height + 5 {
            return .medium
        } else if height > BottomSheetDetent.large.height - 5 && height < BottomSheetDetent.large.height + 5 {
            return .large
        } else {
            return nil
        }
    }
}
