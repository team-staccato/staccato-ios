//
//  CategoryDetailView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

import Kingfisher

struct CategoryDetailView: View {

    let categoryId: Int64
    @ObservedObject var viewModel: CategoryDetailViewModel
    @ObservedObject var homeViewModel: HomeViewModel

    init(_ categoryId: Int64, homeViewModel: HomeViewModel, categoryListViewModel: CategoryListViewModel) {
        self.categoryId = categoryId
        self.viewModel = CategoryDetailViewModel(categoryListViewModel)
        self.homeViewModel = homeViewModel

        viewModel.getCategoryDetail(categoryId)
    }
    
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
                viewModel.deleteCategory()
                homeViewModel.modalNavigationState.path.removeLast()
                print("🥑deleteButton tapped")
            }
        }
    }
}


// MARK: - UI Comonents

extension CategoryDetailView {

    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: viewModel.categoryDetail?.categoryThumbnailUrl ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 240, alignment: .center)
                .clipped()

            Rectangle()
                .foregroundStyle(linearGradient)

            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.categoryDetail?.categoryTitle ?? "")
                    .typography(.title1)
                    .foregroundStyle(.white)
                    .lineLimit(.max)
                    .multilineTextAlignment(.leading)
                
                if let startAt = viewModel.categoryDetail?.startAt,
                   let endAt = viewModel.categoryDetail?.endAt {
                    Text("\(String(describing: startAt)) ~ \(String(describing: endAt))")
                        .typography(.body4)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
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
        Text(viewModel.categoryDetail?.description ?? "")
            .typography(.body2)
            .foregroundStyle(.staccatoBlack)
            .multilineTextAlignment(.leading)
    }

    private var staccatoCollectionSection: some View {
        let staccatos = viewModel.categoryDetail?.staccatos ?? []
        let horizontalInset: CGFloat = 16
        let columnWidth: CGFloat = (ScreenUtils.width - horizontalInset - 8) / 2
        let columns = [
            GridItem(.fixed(columnWidth), spacing: 8),
            GridItem(.fixed(columnWidth))
        ]

        return VStack {
            HStack {
                Text("스타카토")
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
                    .padding(.leading, 4)

                Spacer()

                Button("기록하기") {
                    homeViewModel.modalNavigationState.navigate(to: .staccatoAdd)
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
                                homeViewModel.modalNavigationState.navigate(to: .staccatoDetail(staccato.staccatoId))
                            }
                    }
                }
            }
        }
        .padding(.horizontal, horizontalInset)
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
