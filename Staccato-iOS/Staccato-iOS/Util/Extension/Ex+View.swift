//
//  Ex+View.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/23/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func overlayIf<T: View>(
        _ condition: Bool,
        _ firstContent: () -> T,
        _ secondContent: () -> T = { EmptyView() as! T},
        alignment: Alignment = .center
    ) -> some View {
        if condition {
            self.overlay(alignment: alignment, content: firstContent)
        } else {
            self.overlay(alignment: alignment, content: secondContent)
        }
    }
}
