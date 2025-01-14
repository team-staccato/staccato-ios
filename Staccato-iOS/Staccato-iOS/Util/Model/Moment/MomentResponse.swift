//
//  MomentResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MomentResponse: Codable {
    let momentId: Int64        // Moment ID
    let memoryId: Int64        // Memory ID
    let memoryTitle: String    // Memory 제목
    let startAt: String?       // 시작 시간 (옵셔널)
    let endAt: String?         // 종료 시간 (옵셔널)
    let staccatoTitle: String  // Staccato 제목
    let placeName: String      // 장소 이름
    let latitude: Double       // 위도
    let longitude: Double      // 경도
    let momentImageUrls: [String] // 이미지 URL 목록
    let address: String        // 주소
    let visitedAt: String      // 방문 시간
    let feeling: String        // 느낌
}
