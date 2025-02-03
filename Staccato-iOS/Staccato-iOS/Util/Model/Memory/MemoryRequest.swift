//
//  MemoryRequest.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MemoryRequest: Codable {
    var memoryThumbnailUrl: String?   // 썸네일 URL (선택적)
    var memoryTitle: String           // 메모리 제목
    var description: String?          // 설명 (선택적)
    var startAt: String?              // 시작 시간 (선택적)
    var endAt: String?                // 종료 시간 (선택적)
}
