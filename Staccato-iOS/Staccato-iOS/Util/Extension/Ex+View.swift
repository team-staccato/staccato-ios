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
        _ first: () -> T,
        _ second: () -> U,
        _ alignment: Alignment = .center
    ) -> some View {
        if condition {
            self.overlay(alignment: alignment, content: first)
        } else {
            self.overlay(alignment: alignment, content: second)
        }
    }
}

extension View {
    func dismissKeyboardOnSwipe() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}
