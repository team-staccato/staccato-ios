//
//  StaccatoButtonStyle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/8/25.
//

import SwiftUI

struct StaccatoFilledButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) var isEnabled

    let verticalPadding: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat

    init(
        verticalPadding: CGFloat = 14,
        foregroundColor: Color = .white,
        backgroundColor: Color = .accent,
        cornerRadius: CGFloat = 5
    ) {
        self.verticalPadding = verticalPadding
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalPadding)
            .foregroundStyle(isEnabled ? foregroundColor : .gray4)
            .typography(.title3)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(
                        isEnabled ?
                        (configuration.isPressed ? backgroundColor.opacity(0.7) : backgroundColor)
                        : .gray1
                    )
            }
    }

}

struct StaccatoCapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    let icon: StaccatoIcon
    let font: StaccatoFont
    let spacing: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            Image(icon)
            configuration.label
        }
        .typography(font)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule()
                .stroke(lineWidth: 0.5)
        }
        .foregroundStyle(.gray3)
    }
}

struct StaticTextFieldButtonStyle: ButtonStyle {
    let icon: StaccatoIcon?
    var isActive: Bool

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            if let icon {
                Image(icon)
                    .typography(.body1)
                    .padding(.leading, 16)
                    .foregroundStyle(configuration.isPressed ? .gray3 : .gray4)
            }

            configuration.label
                .typography(.body1)
                .foregroundStyle(isActive ? .staccatoBlack : .gray3)
                .padding(.vertical, 12)
                .padding(.leading, 16)

            Spacer()
        }
        .frame(height: 45)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(configuration.isPressed ? .gray2 : .gray1)
        )
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
