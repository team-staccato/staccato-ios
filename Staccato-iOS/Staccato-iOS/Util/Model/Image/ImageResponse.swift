//
//  ImageResponse.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

struct ImageURL: Codable {
    let imageUrl: String            // 이미지 URL
}

struct ProfileImageURL: Codable {
    let profileImageUrl: String
}

enum imageType {
    case `default`
    case myProfile
    
    var path: String {
            switch self {
            case .default:
                return "/images"
            case .myProfile:
                return "/mypage/images"
            }
        }
}
