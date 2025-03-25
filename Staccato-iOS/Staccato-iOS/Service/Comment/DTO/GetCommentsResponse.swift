//
//  GetCommentsResponse.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/25/25.
//

import Foundation

struct GetCommentsResponse: Decodable {
    
    let comments: [CommentResponse]
    
}

struct CommentResponse: Decodable {
    
    let commentId: Int64
    let memberId: Int64
    let nickname: String
    let memberImageUrl: String?
    let content: String
    
}
