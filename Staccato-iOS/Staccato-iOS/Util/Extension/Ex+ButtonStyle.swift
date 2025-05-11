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
        font: StaccatoFont = .body4,
        iconSpacing: CGFloat = 1,
        horizontalPadding: CGFloat? = 8,
        verticalPadding: CGFloat = 4,
        fullWidth: Bool = false
    ) -> StaccatoCapsuleButtonStyle {
        .init(
            icon: icon,
            font: font,
            iconSpacing: iconSpacing,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            fullWidth: fullWidth
        )
    }
}

extension ButtonStyle where Self == StaccatoFilledButtonStyle {

    static var staccatoFullWidth: StaccatoFilledButtonStyle {
        .init()
    }

    static func staccatoFilled(
        verticalPadding: CGFloat = 14,
        foregroundColor: Color = .staccatoWhite,
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
        isActive: Bool = false
    ) -> StaticTextFieldButtonStyle {
        .init(
            icon: icon,
            isActive: isActive
        )
    }
}
