//
//  CreateCategoryRequestQuery.swift
//  Staccato-iOS
//
//  Created by 정승균 on 3/24/25.
//

import Foundation

struct CreateCategoryRequestQuery: Encodable {
    let categoryThumbnailUrl: String?
    let categoryTitle: String
    let description: String?
    let startAt: String?
    let endAt: String?
}

