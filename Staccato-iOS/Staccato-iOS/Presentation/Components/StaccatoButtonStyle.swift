//
//  StaccatoButtonStyle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/8/25.
//

import SwiftUI

struct StaccatoFullWidthButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(isEnabled ? .white : .gray4)
            .typography(.title3)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(
                        isEnabled ?
                        (configuration.isPressed ? .accent.opacity(0.7) : .accent)
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
    @Binding var isActive: Bool

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
