//
//  CategoryCandidateModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/31/25.
//

import Foundation

struct CategoryCandidateModel {

    let categoryId: Int64
    let categoryTitle: String

}


// MARK: - Mapping: DTO -> Domain Model

extension CategoryCandidateModel {

    init(from dto: GetCategoryCandidatesResponse.CategoryResponse) {
        self.categoryId = dto.categoryId
        self.categoryTitle = dto.categoryTitle
    }

}
