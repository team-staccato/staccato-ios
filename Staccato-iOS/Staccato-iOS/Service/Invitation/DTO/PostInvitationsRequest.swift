//
//  PostInvitationsRequest.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

struct PostInvitationsRequest: Encodable {
    let categoryId: Int64
    let inviteeIds: [Int64]
}
