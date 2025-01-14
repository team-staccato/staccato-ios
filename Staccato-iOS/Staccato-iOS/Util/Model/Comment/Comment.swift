//
//  Comment.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct Comment: Codable {
    let commentId: Int            // 댓글 ID
    let memberId: Int             // 회원 ID
    let nickname: String            // 회원 닉네임
    let memberImageUrl: String?     // 회원 프로필 이미지 URL (옵션)
    let content: String             // 댓글 내용
}
