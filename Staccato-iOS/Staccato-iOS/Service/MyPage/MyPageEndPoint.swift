//
//  MyPageEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Alamofire

enum MyPageEndpoint {
    case getProfile
}

extension MyPageEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getProfile: return "/mypage"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile: return .get
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getProfile: return URLEncoding.default
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getProfile: return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getProfile: return HeaderType.tokenOnly()
        }
    }
}
