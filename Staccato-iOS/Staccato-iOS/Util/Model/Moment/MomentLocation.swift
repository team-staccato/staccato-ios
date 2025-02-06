//
//  Moment.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct MomentLocation: Codable {
    let momentId: Int      // Moment ID
    let latitude: Double     // 위도
    let longitude: Double    // 경도
}
