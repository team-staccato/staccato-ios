//
//  InvitaionModel.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/25/25.
//

import Foundation

struct ReceivedInvitationModel: Equatable, Identifiable {
    
    let id: Int64
    
    let inviterId: Int64
    
    let inviterNickname: String
    
    let inviterProfileImageUrl: String?
    
    let categoryId: Int64
    
    let categoryTitle: String
    
}

// MARK: - Initializer

extension ReceivedInvitationModel {
    
    init(from dto: ReceivedInvitaionResponse) {
        self.id = dto.invitationId
        self.inviterId = dto.inviterId
        self.inviterNickname = dto.inviterNickname
        self.inviterProfileImageUrl = dto.inviterProfileImageUrl
        self.categoryId = dto.categoryId
        self.categoryTitle = dto.categoryTitle
    }
    
}

struct SentInvitationModel: Equatable, Identifiable {
    
    let id: Int64
    
    let inviteeId: Int64
    
    let inviteeNickname: String
    
    let inviteeProfileImageUrl: String?
    
    let categoryId: Int64
    
    let categoryTitle: String
    
}

// MARK: - Initializer

extension SentInvitationModel {
    
    init(from dto: SentInvitaionResponse) {
        self.id = dto.invitationId
        self.inviteeId = dto.inviteeId
        self.inviteeNickname = dto.inviteeNickname
        self.inviteeProfileImageUrl = dto.inviteeProfileImageUrl
        self.categoryId = dto.categoryId
        self.categoryTitle = dto.categoryTitle
    }
    
}
