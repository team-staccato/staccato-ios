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
    
    
    struct MemberModel: Identifiable {
        let id: Int64
        let nickname: String
        let memberImageUrl: String?
        let memberRole: Role
        
        enum Role: String {
            case host
            case invitee
        }
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

    init(from dto: MemberResponse) {
        self.id = dto.memberId
        self.nickname = dto.nickname
        self.memberImageUrl = dto.memberImageUrl
        switch dto.memberRole {
        case "host": self.memberRole = .host
        default: self.memberRole = .invitee
        }
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


// MARK: - Mapping: CategoryDetail -> CategoryCandidate

extension CategoryDetailModel {
    func toCategoryCandidateModel() -> CategoryCandidateModel {
        return CategoryCandidateModel(
            id: self.categoryId,
            categoryId: self.categoryId,
            categoryTitle: self.categoryTitle
        )
    }
}
