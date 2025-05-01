//
//  CreateStaccatoReqeust.swift
//  Staccato-iOS
//
//  Created by 정승균 on 4/20/25.
//

import Foundation

struct CreateStaccatoRequest: Encodable {
    var staccatoTitle: String
    var placeName: String
    var address: String
    var latitude, longitude: Double
    var visitedAt: String
    var categoryId: Int64
    var staccatoImageUrls: [String]
}
