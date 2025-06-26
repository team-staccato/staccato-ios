//
//  LoginEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 2/8/25.
//

import Foundation

import Alamofire

enum LoginEndPoint: APIEndpoint {
    
    case login(nickname: String)
    case recoverAccount(withCode: String)
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .recoverAccount:
            return "/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .recoverAccount:
            return .post
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default
        case .recoverAccount:
            return URLEncoding(destination: .queryString)
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(nickname: let nickname):
            return [
                "nickname": nickname
            ]
        case .recoverAccount(withCode: let code):
            return [
                "code": code
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
