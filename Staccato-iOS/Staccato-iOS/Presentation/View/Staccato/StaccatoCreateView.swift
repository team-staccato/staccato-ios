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
        VStack {
            titleInputSection

            locationInputSection

            dateInputSection

            categorySelectSection
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
    private var titleInputSection: some View {
        VStack(alignment: .leading) {
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
        VStack(alignment: .leading) {
            sectionTitle(title: "장소")

            Button("퍼") {

            }
            .buttonStyle(.staccatoCapsule(icon: .calendar))
        }
    }

    private var dateInputSection: some View {
        VStack(alignment: .leading) {
            sectionTitle(title: "날짜 및 시간")
        }
    }

    private var categorySelectSection: some View {
        VStack(alignment: .leading) {
            sectionTitle(title: "카테고리 선택")
        }
    }

    private func sectionTitle(title: String) -> some View {
        return Group {
            Text(title)
                .foregroundStyle(.staccatoBlack)
            + Text(" *")
                .foregroundStyle(.accent)
        }
        .typography(.title2)
        .padding(.bottom, 10)
    }
}
