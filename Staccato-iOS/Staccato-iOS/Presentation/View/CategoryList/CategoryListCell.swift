//
//  CategoryListCell.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/3/25.
//

import SwiftUI

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
        Image(uiImage: .iconFolder)
            .resizable()
            .foregroundStyle(.gray2)
            .frame(width: 18, height: 18)
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
    
    var periodLabel: some View {
        Text(categoryInfo.startAt + " ~ " + categoryInfo.endAt)
            .typography(.body4)
            .foregroundStyle(.staccatoBlack)
    }
    
    var thumbnailImage: some View {
        categoryInfo.thumbNail?
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 78)
            .clipped()
    }
    
}




#Preview {
    CategoryListCell(
        CategoryModel(
            id: 1,
            thumbNail: Image(uiImage: .staccatoCharacter),
            title: "제주도 가족 여행",
            startAt: "2024.8.16",
            endAt: "2024.8.20"
        )
    )
}
