//
//  Member.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct Member: Codable {
    let memberId: Int64        // 회원 ID
    let nickname: String       // 회원 닉네임
    let memberImage: String?   // 회원 프로필 이미지 URL (옵션)
}
