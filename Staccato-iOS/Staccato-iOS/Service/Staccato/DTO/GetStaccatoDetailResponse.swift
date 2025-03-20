//
//  GetStaccatoDetailResponse.swift
//  Staccato-iOS
//
//  Created by 김유림 on 3/20/25.
//

import Foundation

struct GetStaccatoDetailResponse: Decodable {
    
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
