//
//  CommentResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct CommentsResponse: Codable {
    let comments: [Comment] // 댓글 리스트
}
