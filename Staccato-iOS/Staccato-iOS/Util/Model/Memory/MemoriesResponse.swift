//
//  MemoryResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MemoriesResponse: Codable {
    let memories: [MemoryCandidateResponse]  // 메모리 후보들의 배열
}

struct MemoryCandidateResponse: Codable {
    let memoryId: Int      // 메모리의 고유 ID
    let memoryTitle: String  // 메모리의 제목
    let startAt: String      // 메모리가 시작된 날짜와 시간
    let endAt: String        // 메모리가 끝난 날짜와 시간
}
