//
//  CategoryEditorView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/7/25.
//

import SwiftUI

struct CategoryEditorView: View {
    @State private var categoryTitle = ""
    @FocusState private var isTitleFocused: Bool

    @State private var categoryDescription = ""
    @FocusState private var isDescriptionFocused: Bool

    @State private var isPeriodSettingActive = false
    @State var categoryPeriod: String?
    @State private var isPeriodSheetPresented = false

    private var isSubmitButtonDisabled: Bool {
        return categoryTitle.isEmpty || (isPeriodSettingActive && categoryPeriod == nil)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                photoPlaceholder
                    .padding(.bottom, 36)
                Group {
                    titleInputSection
                        .padding(.bottom, 24)

                    descriptionInputSection
                        .padding(.bottom, 24)

                    periodSettingSection
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 4)

                Spacer()

                Button("저장") {

                }
                .buttonStyle(StaccatoFullWidthButtonStyle())
                .disabled(isSubmitButtonDisabled)
            }
            .animation(.easeIn(duration: 0.15), value: isPeriodSettingActive)
        }
        .padding(.horizontal, 20)

        .sheet(isPresented: $isPeriodSheetPresented) {

        } content: {
            
        }
    }
}

#Preview {
    CategoryEditorView()
}

extension CategoryEditorView {
    private var photoPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(.gray1)
            .overlay {
                VStack(spacing: 0) {
                    Image(systemName: StaccatoIcon.camera.rawValue)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray4)
                        .frame(width: 37)
                        .padding(.bottom, 10)

                    Text("사진을 첨부해주세요")
                        .typography(.body4)
                        .foregroundStyle(.gray4)
                }
            }
            .frame(height: 200)
            .padding(.top, 12)
    }

    private var titleInputSection: some View {
        VStack(alignment: .leading) {
            Group {
                Text("카테고리 제목 ")
                    .foregroundStyle(.staccatoBlack)
                + Text("*")
                    .foregroundStyle(.accent)
            }
            .typography(.title2)
            .padding(.bottom, 8)

            StaccatoTextField(
                text: $categoryTitle,
                isFocused: $isTitleFocused,
                placeholder: "카테고리 제목을 입력해주세요(최대 30자)",
                maximumTextLength: 30
            )
            .focused($isTitleFocused)
        }
    }

    private var descriptionInputSection: some View {
        VStack(alignment: .leading) {
            Text("카테고리 소개")
                .foregroundStyle(.staccatoBlack)
                .typography(.title2)

            TextEditor(text: $categoryDescription)
                .staccatoTextEditorStyle(
                    placeholder: "카테고리 소개를 입력해주세요(최대 500자)",
                    text: $categoryDescription,
                    maximumTextLength: 500,
                    isFocused: $isDescriptionFocused
                )
                .focused($isDescriptionFocused)
        }
    }

    private var periodSettingSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("기간 설정")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)

                Spacer()

                Toggle("", isOn: $isPeriodSettingActive)
                    .toggleStyle(StaccatoToggleStyle())
            }

            Text("'여행'과 같은 카테고리라면 기간을 선택할 수 있어요.")
                .typography(.body4)
                .foregroundStyle(.gray3)
                .padding(.bottom, 12)

            if isPeriodSettingActive {
                Button {
                    isPeriodSheetPresented = true
                } label: {
                    Text(categoryPeriod ?? "카테고리 기간을 선택해주세요")
                        .foregroundStyle(categoryPeriod == nil ? .gray3 : .staccatoBlack)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.gray1)
                        }
                }
            }
        }
    }
}
