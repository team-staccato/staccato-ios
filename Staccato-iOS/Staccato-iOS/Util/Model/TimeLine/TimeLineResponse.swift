//
//  TimeLineResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct TimelineResponse: Codable {
    let memories: [TimelineMemory] // 메모리 목록
}
