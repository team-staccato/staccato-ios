//
//  APIEndPoint.swift
//  Staccato-iOS
//
//  Created by 강재혁 on 1/9/25.
//

import Foundation

enum MemoryAPI: APIEndpoint {
    case searchMemory(memoryId: String)

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
    
    var headers: [String: String]? {
           switch self {
           default:
               return [
                   "Authorization": "Bearer YOUR_ACCESS_TOKEN",
                   "Content-Type": "application/json"
               ]
           }
    }
}
