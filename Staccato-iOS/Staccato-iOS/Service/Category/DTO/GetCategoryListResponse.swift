//
//  GetCategoryListResponse.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/9/25.
//

import Foundation

struct GetCategoryListResponse: Decodable {

    let categories: [CategoryResponse]

    struct CategoryResponse: Decodable {
        let categoryId: Int64
        let categoryThumbnailUrl: String?
        let categoryTitle: String
        let categoryColor: String
        let startAt: String?
        let endAt: String?
        let isShared: Bool
        let members: [MemberResponse]
        let staccatoCount: Int
    }
}
