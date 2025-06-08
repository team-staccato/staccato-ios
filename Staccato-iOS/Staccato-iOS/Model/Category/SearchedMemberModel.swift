//
//  Member.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/21/25.
//

import Foundation

struct SearchedMemberModel: Identifiable, Equatable {
    
    enum Status: String {
        case requested = "REQUESTED"
        case joined = "JOINED"
        case none = "NONE"
    }
    
    let id: Int64
    let nickname: String
    let imageURL: String?
    let status: Status
    var isSelected: Bool = false
    
    init(id: Int64, nickname: String, imageURL: String, status: Status) {
        self.id = id
        self.nickname = nickname
        self.imageURL = imageURL
        self.status = status
    }
}

// MARK: - Mapping DTO
extension SearchedMemberModel {
    init(from dto: MemberResponse) {
        self.id = dto.memberId
        self.nickname = dto.nickname
        self.imageURL = dto.memberImageUrl
        self.status = Status(rawValue: dto.status ?? "none") ?? .none
    }
}
