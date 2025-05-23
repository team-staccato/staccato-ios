//
//  GetCategoryDetailResponse.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/12/25.
//

import Foundation

struct GetCategoryDetailResponse: Decodable {

    let categoryId: Int64
    let categoryThumbnailUrl: String?
    let categoryTitle: String
    let description: String?
    let categoryColor: String
    let startAt: String?
    let endAt: String?
    let isShared: Bool
    let members: [MemberResponse]
    let staccatos: [StaccatoResponse]

    struct MemberResponse: Decodable {
        let memberId: Int64
        let nickname: String
        let memberImageUrl: String?
        let memberRole: String
    }

    struct StaccatoResponse: Decodable {
        let staccatoId: Int64
        let staccatoTitle: String
        let staccatoImageUrl: String?
        let visitedAt: String
    }

}
