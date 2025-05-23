//
//  CategoryDetailView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

import Kingfisher

struct CategoryDetailView: View {

    @Environment(NavigationState.self) var navigationState
    @Environment(StaccatoAlertManager.self) var alertManager
    @EnvironmentObject var homeViewModel: HomeViewModel

    private let categoryId: Int64
    @ObservedObject var viewModel: CategoryViewModel

    @State private var isStaccatoCreateViewPresented = false
    @State private var isCategoryModifyModalPresented = false

    private let horizontalInset: CGFloat = 16

    init(_ categoryId: Int64, _ categoryViewModel: CategoryViewModel) {
        self.categoryId = categoryId
        self.viewModel = categoryViewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerSection

                descriptionSection

                staccatoCollectionSection

                Spacer()
            }
            .frame(width: ScreenUtils.width)
        }
        .background(.staccatoWhite)

        .staccatoNavigationBar {
            Button("수정") {
                isCategoryModifyModalPresented = true
            }

            Button("삭제") {
                withAnimation {
                    alertManager.show(
                        .confirmCancelAlert(
                            title: "삭제하시겠습니까?",
                            message: "삭제를 누르면 복구할 수 없습니다.") {
                                viewModel.deleteCategory()
                                navigationState.dismiss()
                            }
                    )
                }
            }
        }

        .onAppear {
            viewModel.getCategoryDetail(categoryId)
        }

        .onChange(of: homeViewModel.staccatos) {
            viewModel.getCategoryDetail(categoryId)
        }

        .fullScreenCover(isPresented: $isStaccatoCreateViewPresented) {
            StaccatoEditorView(category: viewModel.categoryDetail?.toCategoryModel())
        }

        .fullScreenCover(isPresented: $isCategoryModifyModalPresented) {
            CategoryEditorView(
                categoryDetail: self.viewModel.categoryDetail,
                editorType: .modify,
                categoryViewModel: viewModel
            )
        }
    }

}

// MARK: - UI Components

private extension CategoryDetailView {

    var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: viewModel.categoryDetail?.categoryThumbnailUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: ScreenUtils.width, height: ScreenUtils.width * 0.67, alignment: .center)
                .clipped()

            Rectangle()
                .foregroundStyle(linearGradient)

            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.categoryDetail?.categoryTitle ?? "")
                    .typography(.title1)
                    .foregroundStyle(.staccatoWhite)
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)
                
                if let startAt = viewModel.categoryDetail?.startAt,
                   let endAt = viewModel.categoryDetail?.endAt {
                    Text("\(startAt) ~ \(endAt)")
                        .typography(.body4)
                        .foregroundStyle(.staccatoWhite)
                }
            }
            .padding(.horizontal, horizontalInset)
            .padding(.bottom, 14)
        }
    }

    var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.staccatoBlack.opacity(0.2), location: 0.0),
                .init(color: Color.staccatoBlack.opacity(0.6), location: 0.67),
                .init(color: Color.staccatoBlack.opacity(0.85), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    @ViewBuilder
    var descriptionSection: some View {
        if let description = viewModel.categoryDetail?.description {
            VStack(spacing: 16) {
                Text(description)
                    .typography(.body2)
                    .foregroundStyle(.staccatoBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
            }
            Divider()
        }
    }

    var staccatoCollectionSection: some View {
        let staccatos = viewModel.categoryDetail?.staccatos ?? []
        let columnWidth: CGFloat = (ScreenUtils.width - horizontalInset * 2 - 8) / 2
        let columns = [
            GridItem(.fixed(columnWidth), spacing: 8),
            GridItem(.fixed(columnWidth))
        ]

        return VStack(spacing: 19) {
            HStack {
                Text("스타카토")
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
                    .padding(.leading, 4)

                Spacer()

                Button("기록하기") {
                    isStaccatoCreateViewPresented = true
                }
                .buttonStyle(.staccatoCapsule(icon: .pencilLine))
            }

            if staccatos.isEmpty {
                emptyCollection
                    .padding(.top, 40)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(staccatos) { staccato in
                        StaccatoCollectionCell(staccato, width: columnWidth)
                            .onTapGesture {
                                navigationState.navigate(to: .staccatoDetail(staccato.staccatoId))
                            }
                    }
                }
            }
        }
        .padding(.horizontal, horizontalInset)
    }

    var emptyCollection: some View {
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
