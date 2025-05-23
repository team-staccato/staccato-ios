//
//  PostCategoryRequest.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/22/25.
//

import Foundation

struct PostCategoryRequest: Encodable {
    let categoryThumbnailUrl: String?
    let categoryTitle: String
    let description: String?
    let categoryColor: String
    let startAt: String?
    let endAt: String?
    let isShared: Bool
}
