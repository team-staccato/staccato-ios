//
//  SearchMemberResponse.swift
//  Staccato-iOS
//
//  Created by 김영현 on 5/26/25.
//

import Foundation

struct SearchMemberResponse: Decodable {
    let members: [MemberResponse]
}
