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
        if let thumbnailURL: String = categoryInfo.thumbNailURL {
            KFImage(URL(string: thumbnailURL))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 78)
                .clipShape(RoundedRectangle(cornerRadius: 4))
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
