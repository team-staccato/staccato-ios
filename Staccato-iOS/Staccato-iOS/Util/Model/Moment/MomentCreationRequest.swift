//
//  MomentCreationRequest.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MomentCreationRequest: Codable {
    let staccatoTitle: String      // 스탠카토 제목
    let memoryId: Int64           // 메모리 ID
    let placeName: String         // 장소 이름
    let latitude: Double          // 위도
    let longitude: Double         // 경도
    let address: String           // 주소
    let visitedAt: String         // 방문 시간 (날짜 문자열)
    let momentImageUrls: [String] // 이미지 URL 리스트
}

