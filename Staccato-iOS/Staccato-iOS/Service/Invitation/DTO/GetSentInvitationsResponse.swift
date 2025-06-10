//
//  GetSentInvitationsResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/31/25.
//

import Foundation

struct GetSentInvitationsResponse: Decodable {
    
    let invitations: [SentInvitaionResponse]
    
}

struct SentInvitaionResponse: Decodable {
    
    let invitationId: Int64
    
    let inviteeId: Int64
    
    let inviteeNickname: String
    
    let inviteeProfileImageUrl: String?
    
    let categoryId: Int64
    
    let categoryTitle: String
    
}
