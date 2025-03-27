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
    @State private var isLoading = true
    @State private var image: Image?
    
    init(_ categoryInfo: CategoryModel) {
        self.categoryInfo = categoryInfo
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            folderIcon
            
            Divider()
                .background(.gray2)
                .frame(width: 1)
            
            labelStack
            
            Spacer()
            
            thumbnailImage
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray2, lineWidth: 1)
        )
    }
    
}


// MARK: - UI Components

private extension CategoryListCell {
    
    var folderIcon: some View {
        Image(.folderFill)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
            .foregroundStyle(.gray2)
    }
    
    var labelStack: some View {
        VStack(alignment: .leading) {
            titleLabel
            periodLabel
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
            Text(startAt + " ~ " + endAt)
                .typography(.body4)
                .foregroundStyle(.staccatoBlack)
        }
    }
    
    @ViewBuilder
    var thumbnailImage: some View {
        if let thumbnailURL = categoryInfo.thumbNailURL,
           let url = URL(string: thumbnailURL) {
            ThumbnailImageView(url: url)
        }
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
            Image(.photoBadgeExclamationmark)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray2)
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
            .frame(width: 100, height: 76)
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
            id: 1,
            thumbNailURL: "https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcR0tFzso1HmfFFy1kXeevUflb-F0c5uHZeH5Iqj10Eyu-1FFkJlBuHroyURFRao_3Mmi0b6HaUNP2Vt_jA4pRu4DeckXegB-3yxeFbI084",
            title: "제주도 가족 여행",
            startAt: "2024.8.16",
            endAt: "2024.8.20"
        )
    )
}
