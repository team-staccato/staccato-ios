//
//  CategoryDetailView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

struct CategoryDetailView: View {
    // TODO: Staccato Model 생성 후 수정
    @State var staccatoList: [String] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerSection

                descriptionSection

                Divider()

                staccatoCollectionSection

                Spacer()
            }
        }
        .staccatoNavigationBar {
            Button("수정") {
                // TODO: 수정 기능 구현
            }

            Button("삭제") {
                // TODO: 삭제 기능 구현
            }
        }
    }
}

#Preview("Preview - Empty") {
    NavigationStack {
        CategoryDetailView()
    }
}

#Preview("Preview - with Mock Data") {
    CategoryDetailView(staccatoList: ["광안리", "페스티벌", "공연", "축제"])
}

extension CategoryDetailView {
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            // TODO: 여기에 이미지로 대체...
            Rectangle()
                .foregroundStyle(.red)
            Rectangle()
                .foregroundStyle(linearGradient)

            VStack(alignment: .leading, spacing: 10) {
                // TODO: 날짜 제목 동적으로
                Text("빙글빙글 돌아가는 일상 🍃 (maxline 설정 X, 제목 내용 30글자 다 보여야 함)")
                    .typography(.title1)
                    .foregroundStyle(.white)
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)

                Text("2024. 11. 13 ~ 2024. 11. 21")
                    .typography(.body4)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

        }
        .frame(height: 240)
    }

    private var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.black.opacity(0.2), location: 0.0),
                .init(color: Color.black.opacity(0.6), location: 0.67),
                .init(color: Color.black.opacity(0.85), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var descriptionSection: some View {
        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.  (description)")
            .typography(.body2)
            .foregroundStyle(.staccatoBlack)
            .multilineTextAlignment(.leading)
    }

    private var staccatoCollectionSection: some View {
        let columns = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible())
        ]

        return VStack {
            HStack {
                Text("스타카토")
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
                    .padding(.leading, 4)

                Spacer()

                NavigationLink("기록하기") {
                    StaccatoCreateView(categoryId: 1)
                }
                .buttonStyle(.staccatoCapsule(icon: .pencilLine))
            }

            if staccatoList.isEmpty {
                emptyCollection
                    .padding(.top, 40)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(staccatoList, id: \.self) { staccato in
                        StaccatoCollectionCell(title: staccato, date: .now)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var emptyCollection: some View {
        VStack(spacing: 10) {
            Image(.staccatoCharacter)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 80)

            Text("스타카토를 아직 찍지 않으셨군요!\n스타카토를 찍어볼까요?")
                .typography(.body2)
                .foregroundStyle(.staccatoBlack)
                .multilineTextAlignment(.center)
        }
    }
}
