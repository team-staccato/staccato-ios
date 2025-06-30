//
//  CategoryCandidateModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/31/25.
//

import Foundation

struct CategoryCandidateModel: Hashable, Identifiable {

    let id: Int64
    let categoryTitle: String

}


// MARK: - Mapping: DTO -> Domain Model

extension CategoryCandidateModel {

    init(from dto: GetCategoryCandidatesResponse.CategoryResponse) {
        self.id = dto.categoryId
        self.categoryTitle = dto.categoryTitle
    }

}
