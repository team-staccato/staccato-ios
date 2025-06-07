//
//  GetInvitaionsResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 5/25/25.
//

import Foundation

struct GetReceivedInvitaionsResponse: Decodable {
    
    let invitations: [ReceivedInvitaionResponse]
    
}

struct ReceivedInvitaionResponse: Decodable {
    
    let invitationId: Int64
    
    let inviterId: Int64
    
    let inviterNickname: String
    
    let inviterProfileImageUrl: String?
    
    let categoryId: Int64
    
    let categoryTitle: String
    
}
