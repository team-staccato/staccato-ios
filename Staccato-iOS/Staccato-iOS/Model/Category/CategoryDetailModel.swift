//
//  CategoryDetailModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/12/25.
//

import Foundation

struct CategoryDetailModel {
    
    let categoryId: Int64
    let categoryThumbnailUrl: String?
    let categoryTitle: String
    let description: String?
    let startAt: String?
    let endAt: String?
    let mates: [MateResponse]
    let staccatos: [StaccatoModel]
    
}


struct StaccatoModel: Identifiable {
    
    let id: UUID
    
    let staccatoId: Int64
    let staccatoTitle: String
    let staccatoImageUrl: String?
    let visitedAt: String
    
}


// MARK: - Initializer

extension CategoryDetailModel {
    
    init(from dto: GetCategoryDetailResponse) {
        self.categoryId = dto.categoryId
        self.categoryThumbnailUrl = dto.categoryThumbnailUrl
        self.categoryTitle = dto.categoryTitle
        self.description = dto.description
        self.startAt = dto.startAt
        self.endAt = dto.endAt
        self.mates = dto.mates
        self.staccatos = dto.staccatos.map {
            StaccatoModel(
                id: UUID(),
                staccatoId: $0.staccatoId,
                staccatoTitle: $0.staccatoTitle,
                staccatoImageUrl: $0.staccatoImageUrl,
                visitedAt: $0.visitedAt
            )
        }
    }
    
}
