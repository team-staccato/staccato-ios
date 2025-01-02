//
//  Ex+View+Font.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/3/25.
//

import SwiftUI

extension View {
    func typography(_ font: StaccatoFont) -> some View {
        self
            .font(font.font)
            .kerning(font.kerning)
            .lineSpacing(font.lineSpacing)
    }
}
