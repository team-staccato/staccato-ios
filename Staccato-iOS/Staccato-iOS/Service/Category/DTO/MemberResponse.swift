//
//  MemberResponse.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

struct MemberResponse: Decodable {
    
    let memberId: Int64
    let nickname: String
    let memberImageUrl: String?
    let memberRole: String?
}
