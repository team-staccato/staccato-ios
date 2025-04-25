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

extension ButtonStyle where Self == StaccatoFilledButtonStyle {

    static var staccatoFullWidth: StaccatoFilledButtonStyle {
        .init()
    }

    static func staccatoFilled(
        verticalPadding: CGFloat = 14,
        foregroundColor: Color = .white,
        backgroundColor: Color = .accent
    ) -> StaccatoFilledButtonStyle {
        .init(
            verticalPadding: verticalPadding,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
        )
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
