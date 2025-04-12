//
//  CategoryModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryModel: Identifiable {
    
    let id: UUID
    
    let categoryId: Int64
    
    let thumbNailURL: String?
    
    let title: String
    
    let startAt: String?
    
    let endAt: String?
    
}


// MARK: - Initializer

extension CategoryModel {
    
    init(from dto: CategoryResponse) {
        self.id = UUID()
        self.categoryId = dto.categoryId
        self.thumbNailURL = dto.categoryThumbnailUrl
        self.title = dto.categoryTitle
        self.startAt = dto.startAt
        self.endAt = dto.endAt
    }
    
}
