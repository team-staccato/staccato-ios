//
//  MyPageEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Alamofire

enum MyPageEndpoint {
    case getProfile
    case uploadProfileImage
}

extension MyPageEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getProfile: return "/mypage"
        case .uploadProfileImage: return "/mypage/images"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile: return .get
        case .uploadProfileImage: return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getProfile: return URLEncoding.default
        case .uploadProfileImage: return JSONEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getProfile, .uploadProfileImage: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getProfile, .uploadProfileImage: return HeaderType.tokenOnly()
        }
    }
}
