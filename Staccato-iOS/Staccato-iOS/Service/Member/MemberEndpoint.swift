//
//  MemberEndpoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 3/23/25.
//

import Alamofire

enum MemberEndpoint {
    case getProfile
    case getSearchMemberList(_ name: String, _ excludeCategoryId: Int64)
}

extension MemberEndpoint: APIEndpoint {
    
    var path: String {
        switch self {
        case .getProfile: return "/mypage"
        case .getSearchMemberList: return "/members/search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile: return .get
        case .getSearchMemberList: return .get
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .getProfile:
            return URLEncoding.default
        case .getSearchMemberList:
            return URLEncoding.queryString
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getProfile:
            return nil
        case .getSearchMemberList(let name, let excludeCategoryId):
            return ["nickname": name, "excludeCategoryId": excludeCategoryId]
        }
    }
    
    var headers: [String : String]? {
        return HeaderType.tokenOnly()
    }
}
