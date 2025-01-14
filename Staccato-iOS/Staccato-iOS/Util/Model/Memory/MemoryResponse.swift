//
//  MemoryResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MemoryResponse: Codable {
    var memoryId: Int                  // 메모리 ID
    var memoryThumbnailUrl: String?      // 썸네일 URL (선택적)
    var memoryTitle: String              // 제목
    var startAt: String?                 // 시작 시간 (선택적)
    var endAt: String?                   // 종료 시간 (선택적)
    var description: String?             // 설명 (선택적)
    var mates: [Member]               // 참여한 멤버들
    var moments: [MemoryMoment]       // 관련 모멘트들
}
