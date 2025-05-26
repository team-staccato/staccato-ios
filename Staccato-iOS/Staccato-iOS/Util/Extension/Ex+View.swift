//
//  Ex+View.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/23/25.
//

import SwiftUI

extension View {
    // 조건부 오버레이 (기본값: EmptyView)
    @ViewBuilder
    func overlayIf<T: View>(
        _ condition: Bool,
        _ content: () -> T,
        alignment: Alignment = .center
    ) -> some View {
        if condition {
            self.overlay(alignment: alignment, content: content)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func overlayIf<T: View, U: View>(
        _ condition: Bool,
        _ trueContent: () -> T,
        _ falseContent: () -> U,
        _ alignment: Alignment = .center
    ) -> some View {
        if condition {
            self.overlay(alignment: alignment, content: trueContent)
        } else {
            self.overlay(alignment: alignment, content: falseContent)
        }
    }
}

extension View {
    func dismissKeyboardOnGesture() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}
