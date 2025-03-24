//
//  CreateCategoryRequestQuery.swift
//  Staccato-iOS
//
//  Created by 정승균 on 3/24/25.
//

import Foundation

struct CreateCategoryRequestQuery: Encodable {
    var categoryThumbnailUrl: String?
    var categoryTitle: String
    var description: String?
    var startAt: String?
    var endAt: String?
}

