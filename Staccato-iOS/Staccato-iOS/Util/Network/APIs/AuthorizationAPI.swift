//
//  LoginAPI.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
//

import Foundation

enum AuthorizationAPI: APIEndpoint {
    
    case login(nickname: String)
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: String {
        switch self {
        case .login:
            return "POST"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(nickname: let nickname):
            return [
                "nickname": nickname
            ]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}
