//
//  StaccatoToggleStyle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/7/25.
//

import SwiftUI

/// # StaccatoToggleStyle
///
/// Staccato iOS 앱에서 사용하는 Toggle 스타일입니다.
///
/// - Usage:
/// ```swift
/// @State private var isOn: Bool = false
///
/// var body: some View {
///     Toggle("라벨", isOn: $isOn)
///         .toggleStyle(StaccatoToggleStyle())
/// }
/// ```
struct StaccatoToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule()
                .foregroundStyle(configuration.isOn ? .accent : .gray4)

            HStack {
                if configuration.isOn {
                    Spacer()
                }

                Circle()
                    .foregroundStyle(.white)
                    .padding(2)

                if !configuration.isOn {
                    Spacer()
                }
            }

        }
        .frame(width: 48, height: 20)
        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
        .onTapGesture {
            configuration.isOn.toggle()
        }

    }
}
