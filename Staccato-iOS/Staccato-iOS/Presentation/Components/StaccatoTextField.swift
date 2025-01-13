//
//  StaccatoTextField.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/7/25.
//

import SwiftUI

/// # StaccatoTextField
///
/// Staccato iOS 앱에서 사용하는 TextField입니다. 글자수를 제한하는 기능을 제공합니다.
///
/// - Parameters:
///     - text: 입력 받을 text를 바인딩합니다.
///     - placeholder: 텍스트필드의 설명을 작성합니다.
///     - maximumTextLength: 제한 할 글자수를 지정합니다.
///
/// - Usage:
/// ```swift
/// @State private var text: String = ""
///
/// var body: some View {
///     StaccatoTextField(text: $text, maximumTextLength: 30)
/// }
/// ```
struct StaccatoTextField: View {
    @Binding var text: String
    @FocusState<Bool>.Binding var isFocused: Bool

    let placeholder: String
    let maximumTextLength: Int

    var body: some View {
        VStack {
            TextField("", text: $text)
                .textFieldStyle(StaccatoTextFieldStyle())
                .overlay(alignment: .topLeading) {
                    if !isFocused && text.isEmpty {
                        Text(placeholder)
                            .padding(12)
                            .typography(.body1)
                            .foregroundStyle(.gray3)
                    }
                }
                .onChange(of: text) { _, newValue in
                    if newValue.count > maximumTextLength {
                        text = String(newValue.prefix(maximumTextLength))
                    }
                }

            HStack {
                Spacer()

                Text("\(text.count)/\(maximumTextLength)")
                    .typography(.body3)
                    .foregroundStyle(.gray3)
            }
        }
    }
}

/// # StaccatoTextFieldStyle
///
/// Staccato iOS 앱에서 사용하는 TextField 스타일입니다.
///
/// - Usage:
/// ```swift
/// @State private var text: String = ""
///
/// var body: some View {
///     TextField("텍스트필드 설명", text: $text)
///         .textFieldStyle(StaccatoTextFieldStyle())
/// }
/// ```
struct StaccatoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            configuration
                .typography(.body1)
                .foregroundStyle(.staccatoBlack)
                .padding(12)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            Spacer()
        }
        .frame(height: 45)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.gray1)
        )
    }
}
