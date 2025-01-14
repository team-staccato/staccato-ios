//
//  MemoryMoment.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MemoryMoment: Codable {
    let momentId: Int         // momentId: Long에 해당
    let staccatoTitle: String   // staccatoTitle: String에 해당
    let staccatoImageUrl: String? // momentImageUrl에 해당, 선택적
    let visitedAt: String       // visitedAt에 해당
}
