//
//  MyPageEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Alamofire

enum MyPageEndpoint {
    case getProfile
    case uploadImage
}

extension MyPageEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getProfile: return "/mypage"
        case .uploadImage: return "/mypage/images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile: return .get
        case .uploadImage: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getProfile, .uploadImage: return URLEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getProfile, .uploadImage: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getProfile, .uploadImage: return HeaderType.tokenOnly()
        }
    }
}
