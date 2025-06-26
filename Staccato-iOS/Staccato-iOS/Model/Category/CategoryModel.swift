//
//  CategoryModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/2/25.
//

import SwiftUI

struct CategoryModel: Equatable {

    let id: Int64

    let categoryId: Int64
    let thumbNailURL: String?
    let title: String
    let categoryColor: CategoryColorType
    let startAt: String?
    let endAt: String?
    let isShared: Bool
    let totalMemberCount: Int
    let members: [MemberModel]
    let staccatoCount: Int

    struct MemberModel: Hashable {
        let memberId: Int64
        let nickname: String
        let memberImageUrl: String?
    }

}


// MARK: - Mapping: DTO -> Domain Model

extension CategoryModel {

    init(from dto: GetCategoryListResponse.CategoryResponse) {
        self.id = dto.categoryId
        self.categoryId = dto.categoryId
        self.thumbNailURL = dto.categoryThumbnailUrl
        self.title = dto.categoryTitle
        self.categoryColor = CategoryColorType.fromServerKey(dto.categoryColor)
        self.startAt = dto.startAt
        self.endAt = dto.endAt
        self.isShared = dto.isShared
        self.totalMemberCount = dto.totalMemberCount
        self.members = dto.members.map { MemberModel(from: $0) }
        self.staccatoCount = dto.staccatoCount
    }

}

extension CategoryModel.MemberModel {

    init(from dto: MemberResponse) {
        self.memberId = dto.memberId
        self.nickname = dto.nickname
        self.memberImageUrl = dto.memberImageUrl
    }

}
