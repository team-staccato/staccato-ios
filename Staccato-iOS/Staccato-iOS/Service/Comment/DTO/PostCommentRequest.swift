//
//  PostCommentRequest.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/25/25.
//

import Foundation

struct PostCommentRequest: Encodable {
    
    let staccatoId: Int64
    let content: String
    
}
