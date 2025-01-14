//
//  TimeLineMemory.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct TimelineMemory: Codable {
    let memoryId: Int            // 메모리 고유 ID
    let memoryTitle: String        // 메모리 제목
    let memoryThumbnailUrl: String? // 메모리 썸네일 URL (옵션)
    let startAt: String?           // 메모리 시작 날짜 (옵션)
    let endAt: String?             // 메모리 종료 날짜 (옵션)
    let description: String?       // 메모리 설명 (옵션)
}
