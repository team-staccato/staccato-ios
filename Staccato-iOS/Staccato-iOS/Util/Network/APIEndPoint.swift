//
//  APIEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

enum APIEndpoint {
    case signIn(email: String, password: String)
    case fetchUserProfile(userID: String)

    var baseURL: String {
        return "https://api.example.com"
    }

    var path: String {
        switch self {
        case .signIn:
            return "/auth/signin"
        case .fetchUserProfile(let userID):
            return "/users/\(userID)"
        }
    }

    var method: String {
        switch self {
        case .signIn:
            return "POST"
        case .fetchUserProfile:
            return "GET"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .signIn(let email, let password):
            return ["email": email, "password": password]
        case .fetchUserProfile:
            return nil
        }
    }
}
