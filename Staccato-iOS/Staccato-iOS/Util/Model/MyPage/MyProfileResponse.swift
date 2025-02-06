//
//  MyProfileResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MyProfileResponse: Codable {
    var nickname: String             // 사용자 닉네임
    var profileImageUrl: String?     // 프로필 이미지 URL (선택적)
    var code: String                 // 사용자 코드
}
