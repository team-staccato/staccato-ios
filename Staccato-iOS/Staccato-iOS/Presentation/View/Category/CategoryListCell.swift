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
    
    // TODO: categoryInfo로 대체
    var peopleThumbnails: [String] = ["https://picsum.photos/200", "https://picsum.photos/200","https://picsum.photos/200"]
    var extraPeopleCount: Int = 10
    
    
    init(_ categoryInfo: CategoryModel) {
        self.categoryInfo = categoryInfo
        
        // TODO: 바인딩 수정 (title -> color)
        if let colorType = CategoryColorType(rawValue: categoryInfo.title) {
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
        if let startAt: String = categoryInfo.startAt,
           let endAt: String = categoryInfo.endAt {
            Text(startAt + " - " + endAt)
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
        HStack(spacing: -7) {
            ForEach(peopleThumbnails, id: \.self) { thumbnail in
                if let profileURL = URL(string: thumbnail) {
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

            if extraPeopleCount > 0 {
                Text("+\(extraPeopleCount)")
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
            // TODO: staccatoCount로 수정
            Text(String(categoryInfo.categoryId))
                .typography(.body5) // TODO: 폰트스타일 수정 후 point 12로 수정
        }
        .foregroundStyle(.gray3)
    }

}


// MARK: - Image Loading State

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


#Preview {
    CategoryListCell(
        CategoryModel(
            id: 234,
            categoryId: 234,
            thumbNailURL: "https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcR0tFzso1HmfFFy1kXeevUflb-F0c5uHZeH5Iqj10Eyu-1FFkJlBuHroyURFRao_3Mmi0b6HaUNP2Vt_jA4pRu4DeckXegB-3yxeFbI084",
            title: "제주도 가족 여행",
            startAt: "2024.8.16",
            endAt: "2024.8.20"
        )
    )
}
