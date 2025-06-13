//
//  CommentModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

// MARK: - Model

struct CommentModel: Equatable {
    
    let commentId: Int64
    
    let memberId: Int64
    
    let nickname: String
    
    let memberImageUrl: String?
    
    let content: String
    
}


// MARK: - Initializer

extension CommentModel {
    
    init(from dto: CommentResponse) {
        self.commentId = dto.commentId
        self.memberId = dto.memberId
        self.nickname = dto.nickname
        self.memberImageUrl = dto.memberImageUrl
        self.content = dto.content
    }
    
}
