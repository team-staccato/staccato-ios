//
//  StaccatoTextEditorStyle.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/8/25.
//

import SwiftUI

struct StaccatoTextEditorStyle: ViewModifier {
    @Binding var text: String
    @FocusState<Bool>.Binding var isFocused: Bool

    let placeholder: String
    let maximumTextLength: Int

    init (placeholder: String = "", text: Binding<String>, maximumTextLength: Int, isFocused: FocusState<Bool>.Binding) {
        self.placeholder = placeholder
        self._text = text
        self.maximumTextLength = maximumTextLength
        self._isFocused = isFocused
    }

    func body(content: Content) -> some View {
        VStack {
            content
                .typography(.body1)
                .foregroundStyle(.staccatoBlack)
                .padding(.leading, 12)
                .padding(.top, 3)
                .frame(height: 100)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray1)
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .scrollIndicators(.hidden)
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

extension TextEditor {
    func staccatoTextEditorStyle(placeholder: String, text: Binding<String>, maximumTextLength: Int, isFocused: FocusState<Bool>.Binding) -> some View {
        self.modifier(StaccatoTextEditorStyle(placeholder: placeholder, text: text, maximumTextLength: maximumTextLength, isFocused: isFocused))
    }
}
