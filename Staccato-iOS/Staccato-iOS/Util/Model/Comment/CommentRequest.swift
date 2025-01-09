//
//  CommentResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct CommentRequest: Codable {
    let momentId: Int64       // 게시물 ID (momentId)
    let content: String       // 댓글 내용 (content)
}
