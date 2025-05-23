//
//  ImageResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct ImageResponse: Codable {
    let imageUrl: String            // 이미지 URL
}

struct ProfileImageResponse: Codable {
    let profileImageUrl: String
}
