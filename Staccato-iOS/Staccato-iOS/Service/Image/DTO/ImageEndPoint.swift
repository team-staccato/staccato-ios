//
//  ImageEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 4/25/25.
//

import Alamofire

enum ImageEndPoint {
    case uploadImage
    case uploadProfileImage
}

extension ImageEndPoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .uploadImage: return "/images"
        case .uploadProfileImage: return "/mypage/images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImage, .uploadProfileImage: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .uploadImage, .uploadProfileImage: return URLEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .uploadImage, .uploadProfileImage: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .uploadImage, .uploadProfileImage: return HeaderType.tokenOnly()
        }
    }
}
