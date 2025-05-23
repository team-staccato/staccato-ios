//
//  PutCategoryRequest.swift
//  Staccato-iOS
//
//  Created by 정승균 on 4/22/25.
//

import Foundation

struct PutCategoryRequest: Encodable {
    let categoryThumbnailUrl: String?
    let categoryTitle: String
    let description: String?
    let categoryColor: String
    let startAt: String?
    let endAt: String?
}
