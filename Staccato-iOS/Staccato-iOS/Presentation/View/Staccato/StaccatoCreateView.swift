//
//  StaccatoCreateView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/20/25.
//

import SwiftUI

struct StaccatoCreateView: View {
    @State var title: String = ""
    @FocusState var isTitleFocused: Bool

    var body: some View {
        VStack(spacing: 40) {
            photoInputSection

            titleInputSection

            locationInputSection

            dateInputSection

            categorySelectSection

            Spacer()

            saveButton
        }
        .padding(.horizontal, 24)
        .staccatoNavigationBar(
            title: "스타카토 기록하기",
            subtitle: "기억하고 싶은 순간을 남겨보세요!"
        )
    }
}

#Preview {
    StaccatoCreateView()
}

extension StaccatoCreateView {
    private var photoInputSection: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Text("사진")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)

                Text("(0/5)")
                    .foregroundStyle(.gray3)
                    .typography(.body4)

                Spacer()
            }
            .padding(.bottom, 16)

            photoInputPlaceholder

        }
    }

    private var photoInputPlaceholder: some View {
        VStack(spacing: 8) {
            Image(.camera)
                .frame(width: 28)

            Text("사진을 첨부해 보세요")
                .typography(.body3)
        }
        .foregroundStyle(.gray3)
        .frame(width: 150, height: 150)
        .background(.gray1, in: .rect(cornerRadius: 5))
    }

    private var titleInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "스타카토 제목")

            StaccatoTextField(
                text: $title,
                isFocused: $isTitleFocused,
                placeholder: "어떤 순간이었나요? 제목을 입력해 주세요",
                maximumTextLength: 30
            )
            .focused($isTitleFocused)
        }
    }

    private var locationInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "장소")

            Button("장소명, 주소, 위치로 검색해보세요") {

            }
            .buttonStyle(.staticTextFieldButtonStyle(icon: .magnifyingGlass))
            .padding(.bottom, 10)

            Text("상세 주소")
                .typography(.title3)
                .foregroundStyle(.staccatoBlack)
                .padding(.bottom, 6)

            Text("상세주소는 여기에 표시됩니다.")
                .foregroundStyle(.gray3)
                .typography(.body1)
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.gray2)
                }
                .padding(.bottom, 10)

            Button {

            } label: {
                Label {
                    Text("현재 위치의 주소 불러오기")
                } icon: {
                    Image(.location)
                }
                .foregroundStyle(.gray4)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background {
                    Capsule()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.gray3)
                }

            }
        }
    }

    private var dateInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "날짜 및 시간")

            Button("방문 날짜를 선택해주세요") {

            }
            .buttonStyle(.staticTextFieldButtonStyle())
        }
    }

    private var categorySelectSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionTitle(title: "카테고리 선택")

            Button("카테고리를 선택해주세요") {
                
            }
            .buttonStyle(.staticTextFieldButtonStyle())
        }
    }

    private var saveButton: some View {
        Button("저장") {

        }
        .buttonStyle(.staccatoFullWidth)
        .disabled(true)
    }

    private func sectionTitle(title: String) -> some View {
        return Group {
            Text(title)
                .foregroundStyle(.staccatoBlack)
            + Text(" *")
                .foregroundStyle(.accent)
        }
        .typography(.title2)
        .padding(.bottom, 8)
    }
}
