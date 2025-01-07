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
