//
//  StaccatoModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

struct StaccatoDetailModel: Identifiable {
    
    let id: UUID
    
    let staccatoId: Int64
    let categoryId: Int64
    let categoryTitle: String
    let startAt: String?
    let endAt: String?
    let staccatoTitle: String
    let staccatoImageUrls: [String]
    let visitedAt: String
    let feeling: String
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
    
}

extension StaccatoDetailModel {
    
    static let sample = StaccatoDetailModel(
        id: UUID(),
        staccatoId: 494,
        categoryId: 1,
        categoryTitle: "CategoryTitle",
        startAt: "StartAt",
        endAt: "EndAt",
        staccatoTitle: "StaccatoTitle",
        staccatoImageUrls: [],
        visitedAt: "visitedAt",
        feeling: "feeling",
        placeName: "placeName",
        address: "address",
        latitude: 0.0,
        longitude: 0.0
    )
    
}
