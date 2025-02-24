//
//  StaccatoModel.swift
//  Staccato-iOS
//
//  Created by 김유림 on 2/25/25.
//

import SwiftUI

// TODO: 수정 필요
struct StaccatoModel: Identifiable {
    
    let id: UUID
    
    let momentId: Int64
    
    let memoryId: Int64
    
    let memoryTitle: String
    
    let startAt: String
    
    let endAt: String
    
    let staccatoTitle: String
    
    let momentImages: [Image]
    
    let visitedAt: String
    
    let feeling: String
    
    let placeName: String
    
    let address: String
    
    let latitude: Double
    
    let longitude: Double
    
}

// TODO: 삭제
extension StaccatoModel {
    
    static let sample = StaccatoModel(
        id: UUID(),
        momentId: 1,
        memoryId: 1,
        memoryTitle: "즐거웠던 남산에서의 기억",
        startAt: "2024.01.01",
        endAt: "2024.12.31",
        staccatoTitle: "덕수궁",
        momentImages: [Image("staccato_character"), Image("staccato_character"), Image("staccato_character")],
        visitedAt: "2024.03.03",
        feeling: "happy",
        placeName: "남산서울타워",
        address: "서울 용산구 남산공원길 105",
        latitude: 51.51978412729915,
        longitude: -0.12712788587027796
    )
    
}
