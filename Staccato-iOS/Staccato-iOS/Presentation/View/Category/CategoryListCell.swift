//
//  CategoryListCell.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/3/25.
//

import SwiftUI

import Kingfisher

struct CategoryListCell: View {

    var categoryInfo: CategoryModel
    var colorType: CategoryColorType
    @State private var isLoading = true
    @State private var image: Image?

    init(_ categoryInfo: CategoryModel) {
        self.categoryInfo = categoryInfo

        if let colorType = CategoryColorType.fromServerKey(categoryInfo.categoryColor) {
            self.colorType = colorType
        } else {
            self.colorType = .gray
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            thumbnailImage
            
            VStack(alignment: .leading) {
                HStack {
                    folderIcon
                    labelStack
                }

                Spacer()

                HStack {
                    peopleWithStack
                    Spacer()
                    staccatoCountView
                }
            }
        }
        .padding(.vertical, 13)
        .padding(.horizontal, 18)
    }

}


// MARK: - UI Components

private extension CategoryListCell {

    var folderIcon: some View {
        colorType.folderIcon
    }

    var labelStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            periodLabel
            titleLabel
        }
    }

    var titleLabel: some View {
        Text(categoryInfo.title)
            .typography(.title3)
            .foregroundColor(.staccatoBlack)
    }

    @ViewBuilder
    var periodLabel: some View {
        if let period: String = periodString(startAt: categoryInfo.startAt,
                                             endAt: categoryInfo.endAt) {
            Text(period)
                .typography(.body5)
                .foregroundStyle(.gray3)
        }
    }

    var thumbnailImage: some View {
        Group {
            if let thumbnailURL = categoryInfo.thumbNailURL,
               let url = URL(string: thumbnailURL) {
                ThumbnailImageView(url: url)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray1)
                        .stroke(.gray2, lineWidth: 1)
                    Text("이미지 없음")
                        .typography(.body5)
                        .foregroundStyle(.gray2)
                }
            }
        }
        .frame(width: 86, height: 86)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    var peopleWithStack: some View {
        HStack(spacing: -5) {
            ForEach(categoryInfo.members, id: \.self) { member in
                if let profileStr = member.memberImageUrl,
                   let profileURL = URL(string: profileStr) {
                    KFImage(profileURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color.white, lineWidth: 1)
                        }
                        .frame(width: 24, height: 24)
                } else {
                    Image(.personCircleFill)
                }
            }

            let peoplecount = categoryInfo.members.count
            if peoplecount > 3 {
                Text("+\(peoplecount - 3)")
                    .typography(.body5)
                    .foregroundStyle(colorType.textColor)
                    .background(
                        Circle()
                            .foregroundStyle(colorType.color)
                            .frame(width: 17, height: 17)
                    )
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 1)
                            .frame(width: 17, height: 17)
                    }
            }
        }
        .shadow(color: .shadow, radius: 5)
    }

    var staccatoCountView: some View {
        HStack(spacing: 3) {
            Image(.icMarker)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 10, height: 10)
            Text(String(categoryInfo.staccatoCount))
                .typography(.body5) // TODO: 폰트스타일 수정 후 point 12로 수정
        }
        .foregroundStyle(.gray3)
    }

}


// MARK: - Image Loading State

// TODO: Staccato용으로 만들기
private enum ImageLoadingState {

    case loading
    case loaded(Image)
    case failed
    
    var view: some View {
        switch self {
        case .loading:
            return AnyView(ProgressView())
        case .loaded(let image):
            return AnyView(
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        case .failed:
            return AnyView(
                ImageLoadingErrorView()
            )
        }
    }

}


// MARK: - Error View

private struct ImageLoadingErrorView: View {

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray1)
                .stroke(.gray2, lineWidth: 1)
            
            Image(.photoBadgeExclamationmark)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray1)
    }

}


// MARK: - Thumbnail Image View

private struct ThumbnailImageView: View {

    private let url: URL
    @State private var loadingState: ImageLoadingState = .loading

    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        loadingState.view
            .frame(width: 86, height: 86)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .task {
                await loadImage()
            }
    }

    @MainActor
    private func loadImage() async {
        do {
            let result = try await KingfisherManager.shared.retrieveImage(with: url)
            loadingState = .loaded(Image(uiImage: result.image))
        } catch {
            loadingState = .failed
            print("😢 Failed to load thumbnail: \(error)")
        }
    }

}


// MARK: - Helper

extension CategoryListCell {

    func periodString(startAt: String?, endAt: String?) -> String? {
        guard let startDate = Date.fromString(startAt),
              let endDate = Date.fromString(endAt) else { return nil }
        
        if startDate.year == endDate.year {
            return startDate.formattedAsFullDate + " - " + endDate.formattedAsMonthAndDayDot
        } else {
            return startDate.formattedAsFullDate + " - " + endDate.formattedAsFullDate
        }
    }

}
