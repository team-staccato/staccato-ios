//
//  Ex+ButtonStyle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

extension ButtonStyle where Self == StaccatoCapsuleButtonStyle {
    static func staccatoCapsule(
        icon: StaccatoIcon,
        font: StaccatoFont = .body5,
        spacing: CGFloat = 1
    ) -> StaccatoCapsuleButtonStyle {
        .init(
            icon: icon,
            font: font,
            spacing: spacing
        )
    }
}

extension ButtonStyle where Self == StaccatoFullWidthButtonStyle {
    static var staccatoFullWidth: StaccatoFullWidthButtonStyle {
        .init()
    }
}

extension ButtonStyle where Self == StaticTextFieldButtonStyle {
    static func staticTextFieldButtonStyle(
        icon: StaccatoIcon? = nil,
        isActive: Binding<Bool> = .constant(false)
    ) -> StaticTextFieldButtonStyle {
        .init(
            icon: icon,
            isActive: isActive
        )
    }
}
