//
//  Ex+ButtonStyle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

extension ButtonStyle where Self == StaccatoCapsuleButtonStyle {
    static func staccatoCapsule(icon: StaccatoIcon) -> StaccatoCapsuleButtonStyle {
        .init(icon: icon)
    }
}

extension ButtonStyle where Self == StaccatoFullWidthButtonStyle {
    static var staccatoFullWidth: StaccatoFullWidthButtonStyle {
        .init()
    }
}
