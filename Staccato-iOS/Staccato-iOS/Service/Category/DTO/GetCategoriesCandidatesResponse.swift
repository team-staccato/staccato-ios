//
//  GetCategoriesCandidatesResponse.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/31/25.
//

import Foundation

struct GetCategoriesCandidatesResponse: Decodable {

    let categories: [CategoryResponse]

    struct CategoryResponse: Decodable {
        let categoryId: Int64
        let categoryTitle: String
    }

}
