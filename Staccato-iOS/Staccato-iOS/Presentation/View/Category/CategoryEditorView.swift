//
//  CategoryEditorView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/7/25.
//

import SwiftUI

struct CategoryEditorView: View {
    @State var isPeriodSettingActive = false
    @State var categoryTitle = ""
    @State var categoryDescription = ""

    @State var isAble = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            photoPlaceholder
                .padding(.bottom, 36)

            titleInputSection
                .padding(.bottom, 18)

            descriptionInputSection
                .padding(.bottom, 18)

            periodSettingSection
                .padding(.bottom, 18)

            Spacer()

            Button("저장") {
                isAble.toggle()
            }
            .buttonStyle(StaccatoFullWidthButtonStyle())
        }
        .padding(.horizontal, 24)
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

            StaccatoTextField(text: $categoryTitle, placeholder: "카테고리 제목을 입력해주세요(최대 30자)", maximumTextLength: 30)
        }
    }

    private var descriptionInputSection: some View {
        VStack(alignment: .leading) {
            Text("카테고리 소개")
                .foregroundStyle(.staccatoBlack)
                .typography(.title2)

            StaccatoTextField(text: $categoryDescription, placeholder: "카테고리 소개를 입력해주세요(최대 500자)", maximumTextLength: 500)
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
        }
    }
}
