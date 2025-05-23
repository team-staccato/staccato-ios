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
    let categoryColor: CategoryColorType
    let startAt: String?
    let endAt: String?
    let isShared: Bool
    let members: [MemberModel]
    let staccatos: [StaccatoModel]
    
    
    struct MemberModel: Decodable {
        let memberId: Int64
        let nickname: String
        let memberImageUrl: String?
        let memberRole: String
    }

    struct StaccatoModel: Identifiable {

        let id: Int64

        let staccatoId: Int64
        let staccatoTitle: String
        let staccatoImageUrl: String?
        let visitedAt: String

    }
}


// MARK: - Mapping: DTO -> Domain Model

extension CategoryDetailModel {
    
    init(from dto: GetCategoryDetailResponse) {
        self.categoryId = dto.categoryId
        self.categoryThumbnailUrl = dto.categoryThumbnailUrl
        self.categoryTitle = dto.categoryTitle
        self.description = dto.description
        self.categoryColor = CategoryColorType.fromServerKey(dto.categoryColor)
        self.startAt = dto.startAt
        self.endAt = dto.endAt
        self.isShared = dto.isShared
        self.members = dto.members.map { CategoryDetailModel.MemberModel(from: $0) }
        self.staccatos = dto.staccatos.map {CategoryDetailModel.StaccatoModel(from: $0) }
    }

}

extension CategoryDetailModel.MemberModel {

    init(from dto: GetCategoryDetailResponse.MemberResponse) {
        self.memberId = dto.memberId
        self.nickname = dto.nickname
        self.memberImageUrl = dto.memberImageUrl
        self.memberRole = dto.memberRole
    }

}

extension CategoryDetailModel.StaccatoModel {

    init(from dto: GetCategoryDetailResponse.StaccatoResponse) {
        self.id = dto.staccatoId
        self.staccatoId = dto.staccatoId
        self.staccatoTitle = dto.staccatoTitle
        self.staccatoImageUrl = dto.staccatoImageUrl
        self.visitedAt = dto.visitedAt
    }

}


// MARK: - Mapping: CategoryDetail -> Category

extension CategoryDetailModel {
    func toCategoryModel() -> CategoryModel {
        return CategoryModel(
            id: self.categoryId,
            categoryId: self.categoryId,
            thumbNailURL: self.categoryThumbnailUrl,
            title: self.categoryTitle,
            categoryColor: self.categoryColor,
            startAt: self.startAt,
            endAt: self.endAt,
            isShared: self.isShared,
            members: self.members.map {
                CategoryModel.MemberModel(
                    memberId: $0.memberId,
                    nickname: $0.nickname,
                    memberImageUrl: $0.memberImageUrl
                )
            },
            staccatoCount: self.staccatos.count
        )
    }
}
