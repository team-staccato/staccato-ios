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

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 1) {
            Image(icon)
            configuration.label
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            Capsule()
                .stroke(lineWidth: 0.5)
        }
        .foregroundStyle(.gray3)
    }
}
