//
//  APIEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

enum APIEndpoint {
    case searchMemory(memoryId: String)

    var baseURL: String {
        return "https://stage.staccato.kr"
    }

    var path: String {
        switch self {
        case .searchMemory(memoryId: let memoryId):
            return "/memories/\(memoryId)"
        }
    }

    var method: String {
        switch self {
        case .searchMemory:
            return "GET"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .searchMemory:
            return nil
        }
    }
}
